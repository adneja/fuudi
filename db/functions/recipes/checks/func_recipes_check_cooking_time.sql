CREATE OR REPLACE FUNCTION func_recipes_check_cooking_time(
	p_cooking_time integer
) RETURNS boolean AS $$
	BEGIN
		IF p_cooking_time IS NOT NULL AND NOT p_cooking_time > 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_recipes_check_cooking_time',
				MESSAGE = 'Cooking time must be at least 1 minute',
				DETAIL = 'p_cooking_time: ' || CAST(p_cooking_time AS text);
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_check_cooking_time TO api;
