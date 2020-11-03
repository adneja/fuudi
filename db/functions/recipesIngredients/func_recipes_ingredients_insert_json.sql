CREATE OR REPLACE FUNCTION func_recipes_ingredients_insert_json(
	p_recipe_id integer,
	p_ingredients_json text,
	p_created_by integer
) RETURNS SETOF typ_recipes_ingredients AS $$
	BEGIN
		-- insert ingredients
		INSERT INTO tbl_recipes_ingredients(
			recipe_id,
			fooditem_id,
			measurement_id,
			amount,
			created_by
		) 
		SELECT
			p_recipe_id,
			i.fooditem_id,
			i.measurement_id,
			i.amount,
			p_created_by
		FROM
			json_to_recordset(p_ingredients_json::json) AS i (
				fooditem_id integer,
				measurement_id integer,
				amount integer
			);
		
		-- return recipe ingredients
		RETURN QUERY
			SELECT
				*
			FROM
				viw_recipes_ingredients
			WHERE
				recipe_id = p_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_mealplans_recipes_insert_json TO api;