CREATE FUNCTION func_mealplans_get(
	p_id integer
) RETURNS SETOF tbl_mealplans AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*
			FROM
				tbl_mealplans
			WHERE
				id = p_id;
	END
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_mealplans_get TO api;