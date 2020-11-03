CREATE OR REPLACE FUNCTION func_users_shoppinglist_delete(
	p_created_by integer
) RETURNS SETOF typ_users_shoppinglist AS $$
	BEGIN
		DELETE FROM
			tbl_users_shoppinglist
		WHERE
			created_by = p_created_by;
			
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist
			WHERE
				created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_shoppinglist_delete TO api;