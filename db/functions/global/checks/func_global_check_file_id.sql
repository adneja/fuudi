CREATE OR REPLACE FUNCTION func_global_check_file(
	p_file_id integer
) RETURNS boolean AS $$
	 BEGIN
	 	IF p_file_id IS NOT NULL AND NOT EXISTS(SELECT id FROM tbl_files WHERE id = p_file_id) THEN
			RAISE EXCEPTION USING 
				HINT = 'func_global_check_file',
				MESSAGE = 'Invalid file reference',
				DETAIL = 'p_file_id: ' || CAST(p_file_id AS text);
		END IF;
		
		RETURN true;
	 END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_global_check_file TO api;