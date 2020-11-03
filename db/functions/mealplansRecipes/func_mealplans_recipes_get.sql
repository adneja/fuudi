CREATE OR REPLACE FUNCTION func_mealplans_recipes_get(
	p_mealplan_id integer,
	p_created_by integer DEFAULT null
) RETURNS SETOF typ_recipes AS $$
	BEGIN
		RETURN QUERY
			SELECT 
				r.*,
				0 AS matching_ingredients,
				func_users_recipes_exists(r.id, p_created_by) AS is_favorite
			FROM
				viw_recipes AS r
				INNER JOIN tbl_mealplans_recipes AS mr
					ON r.id = mr.recipe_id
			WHERE
				mr.mealplan_id = p_mealplan_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_mealplans_recipes_get TO api;