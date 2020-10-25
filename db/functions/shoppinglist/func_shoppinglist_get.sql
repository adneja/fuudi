CREATE OR REPLACE FUNCTION func_shoppinglist_get(
	p_created_by integer
) RETURNS SETOF viw_shoppinglist_aggregated AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_shoppinglist_aggregated
			WHERE
				created_by = p_created_by
				AND deleted IS NULL;
				
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_shoppinglist_get TO api;