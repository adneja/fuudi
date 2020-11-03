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
		-- check if passwords match
		IF p_password <> p_repeat_password THEN 
			RAISE EXCEPTION USING
				MESSAGE = 'Passwords do not match.';
		END IF;
		
		-- insert user
		INSERT INTO tbl_users(
			email,
			name,
			password
		) VALUES (
			p_email,
			p_name,
			crypt(p_password, gen_salt('bf'))
		) RETURNING id INTO v_new_user_id;
		
		-- return new user row
		RETURN QUERY
			SELECT * FROM viw_users WHERE id = v_new_user_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_create TO api;