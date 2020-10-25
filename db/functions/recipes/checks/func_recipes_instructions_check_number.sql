CREATE OR REPLACE FUNCTION func_recipes_instructions_check_number(
	p_recipe_id integer,
	p_number integer
) RETURNS boolean AS $$
	BEGIN
		IF p_number IS NOT NULL AND NOT p_number > 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_instructions_check_number',
				MESSAGE = 'Number cannot be 0',
				DETAIL = 'p_number: ' || CAST(p_number AS text);
		END IF;
		
		IF p_number IS NOT NULL AND EXISTS(SELECT id FROM tbl_recipes_instructions WHERE recipe_id = p_recipe_id AND number = p_number) THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_instructions_check_number',
				MESSAGE = 'Number must be unique',
				DETAIL = 'p_number: ' || CAST(p_number AS text) || ', p_recipe_id: ' || CAST(p_recipe_id AS text);
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_instructions_check_number TO api;
