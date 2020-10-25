CREATE OR REPLACE FUNCTION func_files_check_mimetype(
	p_mimetype text
) RETURNS boolean AS $$
	BEGIN
		IF p_mimetype IS NOT NULL AND split_part(p_mimetype, '/', 1) <> 'image'  THEN
			RAISE EXCEPTION USING
				HINT = 'func_files_check_mimetype',
				MESSAGE = 'File must be an image',
				DETAIL = 'p_mimetype: ' || p_mimetype;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_files_check_mimetype TO api;

