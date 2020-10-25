CREATE OR REPLACE FUNCTION func_recipes_get(
	p_id integer
) RETURNS SETOF viw_recipes AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes
			WHERE
				id = p_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_get TO api;