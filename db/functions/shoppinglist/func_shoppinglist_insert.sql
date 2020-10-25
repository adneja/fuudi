CREATE OR REPLACE FUNCTION func_shoppinglist_insert (
	p_items text,
	p_created_by integer
) RETURNS SETOF viw_shoppinglist_aggregated AS $$
	BEGIN
		-- validate input
		IF p_items IS NULL OR char_length(p_items) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing shopping list data.';
		END IF;
		
		-- if user has any of the items in shopping list that are already checked -> delete them
		WITH items AS (
			SELECT
				i.fooditem_id,
				i.amount,
				i.measurement_id,
				p_created_by
			FROM
				json_to_recordset(p_items::json) AS i (
					fooditem_id integer,
					amount integer,
					measurement_id integer)
		)
		UPDATE 
			tbl_shoppinglist
		SET 
			deleted = now()
		WHERE 
			checked IS NOT NULL
			AND fooditem_id IN (SELECT fooditem_id FROM items)
			AND created_by = p_created_by;
		
		-- insert new items 
		INSERT INTO tbl_shoppinglist (
			fooditem_id,
			amount,
			measurement_id,
			created_by
		)
		SELECT
			i.fooditem_id,
			i.amount,
			i.measurement_id,
			p_created_by
		FROM
			json_to_recordset(p_items::json) AS i (
				fooditem_id integer,
				amount integer,
				measurement_id integer
			);
			
		-- return users updated shopping list
		RETURN QUERY
			SELECT * FROM viw_shoppinglist_aggregated WHERE created_by = p_created_by AND deleted IS NULL ORDER BY fooditem_name ASC;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_shoppinglist_insert TO api;


