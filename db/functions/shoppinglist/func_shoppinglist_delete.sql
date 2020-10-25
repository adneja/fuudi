CREATE OR REPLACE FUNCTION func_shoppinglist_delete (
	p_all boolean,
	p_created_by integer
) RETURNS SETOF viw_shoppinglist_aggregated AS $$
	BEGIN
		-- validate input
		IF p_all IS NULL THEN
			RAISE EXCEPTION USING HINT = 'ALl/checked argument missing';
		END IF;
		
		-- delete data
		IF p_all = true THEN
			UPDATE 
				tbl_shoppinglist
			SET
				deleted = now()
			WHERE
				created_by = p_created_by;
		ELSE
			UPDATE 
				tbl_shoppinglist
			SET
				deleted = now()
			WHERE
				created_by = p_created_by
				AND checked IS NOT NULL;
		END IF;

		
		-- return updated shopping list
		RETURN QUERY
			SELECT * FROM viw_shoppinglist_aggregated WHERE created_by = p_created_by AND deleted IS NULL ORDER BY fooditem_name ASC;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_shoppinglist_delete TO api;

