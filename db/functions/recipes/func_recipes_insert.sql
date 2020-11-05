CREATE OR REPLACE FUNCTION func_recipes_insert(
	p_name text,
	p_description text,
	p_cooking_time integer,
	p_portions integer,
	p_file_id integer,
	p_ingredients_json text,
	p_instructions_json text,
	p_created_by integer
) RETURNS SETOF tbl_recipes AS $$
	DECLARE
		v_new_recipe_id integer;
	BEGIN		
		-- insert recipe
		INSERT INTO tbl_recipes(
			name,
			description,
			cooking_time,
			portions,
			file_id,
			created_by
		) VALUES (
			p_name,
			p_description,
			p_cooking_time,
			p_portions,
			p_file_id,
			p_created_by
		) RETURNING id INTO v_new_recipe_id;
		
		-- insert ingredients
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
			json_to_recordset(p_ingredients_json::json) AS i (
				fooditem_id integer,
				measurement_id integer,
				amount integer
			);
			
		-- insert instructions
		INSERT INTO tbl_recipes_instructions(
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
			json_to_recordset(p_instructions_json::json) AS i (
				number integer,
				instruction text
			);
			
		-- validate ingredients
		IF NOT EXISTS(SELECT recipe_id FROM tbl_recipes_ingredients WHERE recipe_id = v_new_recipe_id) THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_insert',
				MESSAGE = 'Please add one or more ingredients',
				DETAIL = '';
		END IF;
		
		-- validate instructions
		IF NOT EXISTS(SELECT recipe_id FROM tbl_recipes_instructions WHERE recipe_id = v_new_recipe_id) THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_insert',
				MESSAGE = 'Please add one or more instructions',
				DETAIL = '';
		END IF;
		
		-- return new recipe
		RETURN QUERY
			SELECT * FROM tbl_recipes WHERE id = v_new_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_insert TO api;