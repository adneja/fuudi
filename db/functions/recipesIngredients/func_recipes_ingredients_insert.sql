CREATE OR REPLACE FUNCTION func_recipes_ingredients_insert(
	p_recipe_id integer,
	p_fooditem_id integer,
	p_measurement_id integer,
	p_amount_id integer,
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
		) VALUES (
			p_recipe_id,
			p_fooditem_id,
			p_measurement_id,
			p_amount_id,
			p_created_by
		);
		
		-- return recipes ingredients
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_recipes_ingredients 
			WHERE 
				recipe_id = p_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_ingredients_insert TO api;