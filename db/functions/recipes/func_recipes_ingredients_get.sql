CREATE OR REPLACE FUNCTION func_recipes_ingredients_get(
	p_recipe_id integer
) RETURNS SETOF viw_recipes_ingredients AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_ingredients
			WHERE
				recipe_id = p_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_ingredients_get TO api;