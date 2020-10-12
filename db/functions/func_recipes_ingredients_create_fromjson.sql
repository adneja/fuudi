DROP FUNCTION func_recipes_ingredients_create_fromjson;

CREATE FUNCTION func_recipes_ingredients_create_fromjson(
	p_name text,
	p_description text,
	p_cooking_time integer,
	p_portions integer,
	p_ingredients text,
	p_instructions text,
	p_created_by integer
)
RETURNS SETOF tbl_recipes
LANGUAGE plpgsql
AS $$
	DECLARE
		v_new_recipe_id integer;
	BEGIN
		-- create recipe
		INSERT INTO tbl_recipes(
			name,
			description,
			cooking_time,
			portions,
			created_by
		) VALUES (
			p_name,
			p_description,
			p_cooking_time,
			p_portions,
			p_created_by
		) RETURNING id INTO v_new_recipe_id;
		
		
		-- add ingredients
		INSERT INTO tbl_recipes_ingredients(
			recipe_id,
			fooditem_id,
			measurement_id,
			amount,
			created_by
		)
		SELECT
			v_new_recipe_id,
			i.fooditem_id,
			i.measurement_id,
			i.amount,
			p_created_by
		FROM
			json_to_recordset(p_ingredients::json) AS i (
				fooditem_id integer,
				measurement_id integer,
				amount integer
			);
			
		-- add instructions
		INSERT INTO tbl_recipes_instructions (
			recipe_id,
			number,
			instruction,
			created_by
		)
		SELECT
			v_new_recipe_id,
			i.number,
			i.instruction,
			p_created_by
		FROM
			json_to_recordset(p_instructions::json) AS i (
				number integer,
				instruction text
			);
			
		RETURN QUERY
			SELECT * FROM tbl_recipes WHERE id = v_new_recipe_id;
	END;
$$;

GRANT EXECUTE ON FUNCTION func_recipes_ingredients_create_fromjson TO api;