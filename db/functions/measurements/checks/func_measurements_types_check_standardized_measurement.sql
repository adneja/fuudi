CREATE OR REPLACE FUNCTION func_measurements_types_check_standardized_measurement(
	p_standardized_measurement text
) RETURNS boolean AS $$
	BEGIN
		IF p_standardized_measurement IS NOT NULL AND char_length(trim(p_standardized_measurement)) = 0 THEN
			RAISE EXCEPTION USING 
				HINT = 'func_measurements_types_check_standardized_measurement',
				MESSAGE = 'Standardized measurement must be longer than 0 characters',
				DETAIL = 'p_standardized_measurement: ' || p_name;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_measurements_types_check_standardized_measurement TO api;