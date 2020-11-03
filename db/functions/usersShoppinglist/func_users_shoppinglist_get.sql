CREATE OR REPLACE FUNCTION func_users_shoppinglist_get(
	p_created_by integer
) RETURNS SETOF typ_users_shoppinglist AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist
			WHERE
				created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;


GRANT EXECUTE ON FUNCTION func_users_shoppinglist_get TO api;