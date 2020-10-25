CREATE OR REPLACE FUNCTION func_users_check_email(
	p_email text
) RETURNS boolean AS $$
	BEGIN
		IF p_email IS NOT NULL AND char_length(trim(p_email)) = 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_users_check_email',
				MESSAGE = 'Missing email',
				DETAIL = 'p_email: '|| p_email;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_check_email TO api;