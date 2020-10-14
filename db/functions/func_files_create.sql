DROP FUNCTION func_files_create;

CREATE FUNCTION func_files_create(
	p_name text,
	p_size integer,
	p_mimetype text,
	p_created_by integer
) RETURNS SETOF tbl_files AS $$
	DECLARE	
		v_new_file_id integer;
	BEGIN
		INSERT INTO tbl_files(
			name,
			size,
			mimetype,
			created_by
		) VALUES (
			p_name,
			p_size,
			p_mimetype,
			p_created_by
		) RETURNING id INTO v_new_file_id;
		
		RETURN QUERY
			SELECT * FROM tbl_files WHERE id = v_new_file_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_files_create TO api;