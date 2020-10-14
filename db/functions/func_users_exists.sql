DROP FUNCTION func_users_exists;

CREATE FUNCTION func_users_exists(
	p_email text
) RETURNS boolean AS $$
	BEGIN
		RETURN EXISTS(SELECT email FROM tbl_users WHERE email = p_email);
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_exists TO api;