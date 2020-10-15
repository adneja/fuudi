DROP FUNCTION func_users_create;

CREATE FUNCTION func_users_create(
	p_email text,
	p_name text,
	p_password text,
	p_repeat_password text
) RETURNS SETOF viw_users AS $$
	DECLARE
		v_new_user_id integer;
	BEGIN
		IF p_email IS NULL OR CHAR_LENGTH(p_email) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing email.';
		END IF;
		
		IF p_name IS NULL OR CHAR_LENGTH(p_name) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing name.';
		END IF;
		
		IF p_password IS NULL OR CHAR_LENGTH(p_password) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing password.';
		END IF;
		
		IF p_password <> p_repeat_password THEN 
			RAISE EXCEPTION USING HINT = 'Passwords do not match.';
		END IF;
		
		IF EXISTS(SELECT id FROM tbl_users WHERE email = p_email) THEN
			RAISE EXCEPTION USING HINT = 'Email is already in use.';
		END IF;
		
		INSERT INTO tbl_users(
			email,
			name,
			password
		) VALUES (
			p_email,
			p_name,
			crypt(p_password, gen_salt('bf'))
		) RETURNING id INTO v_new_user_id;
		
		RETURN QUERY
			SELECT * FROM viw_users WHERE id = v_new_user_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_create TO api;