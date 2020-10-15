DROP FUNCTION func_recipes_create;

CREATE FUNCTION func_recipes_create(
	p_name text,
	p_description text,
	p_cooking_time integer,
	p_portions integer,
	p_file_id integer,
	
	p_vegan boolean,
	p_vegetarian boolean,
	p_gluten_free boolean,
	
	p_allergen_milk boolean,
	p_allergen_egg boolean,
	p_allergen_nuts boolean,
	p_allergen_wheat boolean,
	p_allergen_soy boolean,
	p_allergen_fish boolean,
	p_allergen_shellfish boolean,
	
	p_ingredients text,
	p_instructions text,
	p_created_by integer
) RETURNS SETOF tbl_recipes AS $$
	DECLARE
		v_new_recipe_id integer;
	BEGIN
		IF p_name IS NULL OR char_length(p_name) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing title.';
		END IF;
		
		IF p_description IS NULL OR char_length(p_description) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing description.';
		END IF;
		
		IF p_cooking_time IS NULL OR p_cooking_time = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing cooking time.';
		END IF;
		
		IF p_portions IS NULL OR p_portions = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing portions.';
		END IF;
		
		IF NOT EXISTS(SELECT id FROM tbl_files WHERE id = p_file_id) THEN
			RAISE EXCEPTION USING HINT = 'Missing image.';
		END IF;
		
		-- create recipe
		INSERT INTO tbl_recipes(
			name,
			description,
			cooking_time,
			portions,
			file_id,
			
			vegan,
			vegetarian,
			gluten_free,
			
			allergen_milk,
			allergen_egg,
			allergen_nuts,
			allergen_wheat,
			allergen_soy,
			allergen_fish,
			allergen_shellfish,
			
			created_by
		) VALUES (
			p_name,
			p_description,
			p_cooking_time,
			p_portions,
			p_file_id,
			
			p_vegan,
			p_vegetarian,
			p_gluten_free,
			
			p_allergen_milk,
			p_allergen_egg,
			p_allergen_nuts,
			p_allergen_wheat,
			p_allergen_soy,
			p_allergen_fish,
			p_allergen_shellfish,
			
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
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_create TO api;