DROP FUNCTION func_users_exists;

CREATE FUNCTION func_users_exists(
	p_email TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN EXISTS(SELECT email FROM tbl_users WHERE email = p_email);
	END;
$$;

GRANT EXECUTE ON FUNCTION func_users_exists TO api;