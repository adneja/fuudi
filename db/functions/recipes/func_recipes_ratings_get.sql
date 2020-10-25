CREATE OR REPLACE FUNCTION func_recipes_ratings_get(
	p_recipe_id integer
) RETURNS SETOF viw_recipes_ratings AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_ratings
			WHERE
				recipe_id = p_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_ratings_get TO api;