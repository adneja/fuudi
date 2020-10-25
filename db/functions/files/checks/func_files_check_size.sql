CREATE OR REPLACE FUNCTION func_files_check_size(
	p_size integer
) RETURNS boolean AS $$
	BEGIN
		IF p_size IS NOT NULL AND NOT p_size > 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_files_check_size',
				MESSAGE = 'File size must be larger than 0',
				DETAIL = 'p_size: ' || CAST(p_size AS text);
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_files_check_size TO api;


