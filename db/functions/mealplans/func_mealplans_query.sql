CREATE OR REPLACE FUNCTION func_mealplans_query(
	p_search text,
	p_created_by integer DEFAULT null
) RETURNS SETOF typ_mealplans AS $$
	BEGIN
		RETURN QUERY
			SELECT
				m.*,
				func_users_mealplans_exists(m.id, p_created_by) AS is_favorite
			FROM
				viw_mealplans AS m
			WHERE
				(lower(name) || lower(COALESCE(description, ''))) LIKE ('%' || p_search || '%');
				
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_mealplans_query TO api;