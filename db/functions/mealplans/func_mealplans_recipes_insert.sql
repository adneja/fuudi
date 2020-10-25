CREATE OR REPLACE FUNCTION func_mealplans_recipes_insert(
	p_mealplan_id integer,
	p_recipes_json text,
	p_created_by integer
) RETURNS SETOF tbl_mealplans_recipes AS $$
	BEGIN
		-- add recipes
		INSERT INTO tbl_mealplans_recipes(
			mealplan_id,
			recipe_id,
			created_by
		)
		SELECT
			p_mealplan_id,
			i.id,
			p_created_by
		FROM
			json_to_recordset(p_recipes_json::json) AS i (
				id integer
			);
			
		RETURN QUERY
			SELECT * FROM tbl_mealplans_recipes WHERE mealplan_id = p_mealplan_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_mealplans_recipes_insert TO api;