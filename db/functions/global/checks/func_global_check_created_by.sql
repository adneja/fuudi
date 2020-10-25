CREATE OR REPLACE FUNCTION func_global_check_created_by(
	p_created_by integer
) RETURNS boolean AS $$
	BEGIN
		IF p_created_by IS NOT NULL AND NOT EXISTS(SELECT id FROM tbl_users WHERE id = p_created_by) THEN
			RAISE EXCEPTION USING
				HINT = 'func_global_check_created_by',
				MESSAGE = 'Invalid user_id',
				DETAIL = 'p_created_by: ' || p_created_by;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_global_check_created_by TO api;

