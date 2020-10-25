CREATE OR REPLACE FUNCTION func_measurements_query(
	p_search text
) RETURNS SETOF tbl_measurements AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				tbl_measurements
			WHERE
				(lower(name) || lower(long_name)) LIKE '%' || lower(p_search) || '%';
	END;
$$ LANGUAGE plpgsql;


GRANT EXECUTE ON FUNCTION func_measurements_query TO api;