DROP FUNCTION func_shoppinglist_check;

CREATE FUNCTION func_shoppinglist_check(
	p_check boolean,
	p_fooditem_id integer,
	p_created_by integer
) RETURNS SETOF viw_shoppinglist_aggregated AS $$
	BEGIN
		UPDATE 
			tbl_shoppinglist
		SET
			checked = CASE
				WHEN p_check = true THEN now()
				ELSE NULL
			END
		WHERE
			fooditem_id = p_fooditem_id
			AND created_by = p_created_by;
			
		RETURN QUERY
			SELECT * FROM viw_shoppinglist_aggregated WHERE created_by = p_created_by AND deleted IS NULL ORDER BY fooditem_name ASC;
		
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_shoppinglist_check TO api;