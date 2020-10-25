CREATE OR REPLACE FUNCTION func_users_check_password(
	p_password text
) RETURNS boolean AS $$
	BEGIN
		IF p_password IS NOT NULL AND char_length(trim(p_password)) = 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_users_check_password',
				MESSAGE = 'Missing password',
				DETAIL = 'p_password: '|| p_password;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_check_password TO api;