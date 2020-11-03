CREATE OR REPLACE FUNCTION func_recipes_instructions_get(
	p_recipe_id integer
) RETURNS SETOF typ_recipes_instructions AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_instructions
			WHERE
				recipe_id = p_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_instructions_get TO api;



