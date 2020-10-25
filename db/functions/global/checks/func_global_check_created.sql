CREATE OR REPLACE FUNCTION func_global_check_created(
	p_created timestamp
) RETURNS boolean AS $$
	BEGIN
		IF p_created IS NOT NULL AND p_created > now() THEN
			RAISE EXCEPTION USING
				HINT = 'func_global_check_created',
				MESSAGE = 'Created timestamp can not be from the future',
				DETAIL = 'p_created: ' || p_created;
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_global_check_created TO api;

