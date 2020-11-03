CREATE OR REPLACE FUNCTION func_fooditems_query(
	p_search text
) RETURNS SETOF typ_fooditems AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				viw_fooditems
			WHERE
				lower(name) LIKE '%' || lower(p_search) || '%';
	END;
$$ LANGUAGE plpgsql;


GRANT EXECUTE ON FUNCTION func_fooditems_query TO api;