CREATE OR REPLACE FUNCTION func_recipes_check_portions(
	p_portions integer
) RETURNS boolean AS $$
	BEGIN
		IF p_portions IS NOT NULL AND NOT p_portions > 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_recipes_check_cooking_time',
				MESSAGE = 'Portions cannot be 0',
				DETAIL = 'p_portions: ' || CAST(p_portions AS text);
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_check_portions TO api;
