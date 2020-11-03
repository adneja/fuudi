CREATE OR REPLACE FUNCTION func_mealplans_get(
	p_id integer,
	p_created_by integer DEFAULT null
) RETURNS SETOF typ_mealplans AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*,
				func_users_mealplans_exists(p_id, p_created_by) AS is_favorite
			FROM
				viw_mealplans
			WHERE
				id = p_id;
	END
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_mealplans_get TO api;



