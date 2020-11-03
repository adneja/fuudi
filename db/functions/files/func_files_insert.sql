CREATE OR REPLACE FUNCTION func_files_insert(
	p_name text,
	p_size integer,
	p_mimetype text,
	p_created_by integer
) RETURNS SETOF typ_files AS $$
	DECLARE	
		v_new_file_id integer;
	BEGIN		
		-- insert file
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
		
		-- return new file row
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_files 
			WHERE 
				id = v_new_file_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_files_insert TO api;