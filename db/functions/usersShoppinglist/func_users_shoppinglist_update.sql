CREATE OR REPLACE FUNCTION func_users_shoppinglist_update(
	p_fooditem_id integer,
	p_checked boolean,
	p_created_by integer
) RETURNS SETOF typ_users_shoppinglist AS $$
	BEGIN
		UPDATE 
			tbl_users_shoppinglist
		SET
			checked = p_checked
		WHERE
			fooditem_id = p_fooditem_id
			AND created_by = p_created_by;
			
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist
			WHERE
				created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_shoppinglist_update TO api;