CREATE OR REPLACE FUNCTION func_recipes_check_description(
	p_description text
) RETURNS boolean AS $$
	BEGIN
		IF p_description IS NOT NULL AND char_length(trim(p_description)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_recipes_check_name',
				MESSAGE = 'Name must be longer than 0 characters',
				DETAIL = 'p_description: ' || p_description;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_check_description TO api;
