DROP FUNCTION func_recipes_ingredients_create;

CREATE FUNCTION func_recipes_ingredients_create(
	p_recipe_id integer,
	p_fooditem_id integer,
	p_measurement_id integer,
	p_amount integer,
	p_created_by integer
)
RETURNS SETOF tbl_recipes_ingredients
LANGUAGE plpgsql
AS $$
	DECLARE
		v_new_recipe_ingredient_id integer;
	BEGIN
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
			p_amount,
			p_created_by
		) RETURNING id INTO v_new_recipe_ingredient_id;
		
		RETURN QUERY
			SELECT * FROM tbl_recipes_ingredients WHERE id = v_new_recipe_ingredient_id;
	END;
$$;

GRANT EXECUTE ON FUNCTION func_recipes_ingredients_create TO API;