CREATE OR REPLACE FUNCTION func_recipes_ingredients_insert(
	p_recipe_id integer,
	p_ingredients_json text,
	p_created_by integer
) RETURNS SETOF tbl_recipes_ingredients AS $$
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
			
		RETURN QUERY
			SELECT * FROM tbl_recipes_ingredients WHERE recipe_id = p_recipe_id AND created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_ingredients_insert TO api;