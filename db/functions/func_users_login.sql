DROP FUNCTION func_users_login;

CREATE FUNCTION func_users_login(
	p_email text,
	p_password text
) RETURNS SETOF viw_users AS $$
	DECLARE
		v_user_id integer;
	BEGIN
		SELECT
			id
		INTO
			v_user_id
		FROM
			tbl_users
		WHERE
			email = p_email
			AND password = crypt(p_password, password);
			
		IF v_user_id IS NULL THEN
			RAISE EXCEPTION USING HINT = 'Invalid credentials.';
		ELSE
			RETURN QUERY
				SELECT * FROM viw_users WHERE id = v_user_id;
		END IF;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_login TO api;