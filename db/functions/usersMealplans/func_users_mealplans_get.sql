CREATE OR REPLACE FUNCTION func_users_mealplans_get(
	p_created_by integer
) RETURNS SETOF typ_mealplans AS $$
	BEGIN
		RETURN QUERY
			SELECT
				m.*,
				func_users_mealplans_exists(m.id, p_created_by) AS is_favorite
			FROM
				viw_mealplans AS m
				INNER JOIN tbl_users_mealplans AS um
					ON m.id = um.mealplan_id
			WHERE
				um.created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql	;

GRANT EXECUTE ON FUNCTION func_users_mealplans_get TO api;