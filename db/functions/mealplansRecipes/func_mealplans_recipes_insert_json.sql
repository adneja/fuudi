CREATE OR REPLACE FUNCTION func_mealplans_recipes_insert_json(
	p_mealplan_id integer,
	p_recipes_json text,
	p_created_by integer
) RETURNS SETOF typ_recipes AS $$
	BEGIN
		-- insert mealplan recipes
		INSERT INTO tbl_mealplans_recipes(
			mealplan_id,
			recipe_id,
			created_by
		) 
		SELECT
			p_mealplan_id,
			r.recipe_id,
			p_created_by
		FROM
			json_to_recordset(p_recipes_json::json) AS r (
				recipe_id integer
			);
		
		-- return mealplan recipes
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

GRANT EXECUTE ON FUNCTION func_mealplans_recipes_insert_json TO api;