CREATE OR REPLACE FUNCTION func_mealplans_recipes_get(
	p_mealplan_id integer
) RETURNS SETOF tbl_mealplans_recipes AS $$
	BEGIN
		RETURN QUERY
			SELECT 
				*
			FROM
				tbl_mealplans_recipes
			WHERE
				mealplan_id = p_mealplan_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_mealplans_recipes_get TO api;