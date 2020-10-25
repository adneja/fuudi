CREATE OR REPLACE FUNCTION func_recipes_instructions_check_instruction(
	p_instruction text
) RETURNS boolean AS $$
	BEGIN
		IF p_instruction IS NOT NULL AND char_length(p_instruction) < 5 THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_instructions_check_instruction',
				MESSAGE = 'Instruction must be longer than 5 characters',
				DETAIL = 'p_instruction: ' || p_instruction;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_instructions_check_instruction TO api;