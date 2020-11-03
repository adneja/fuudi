CREATE OR REPLACE FUNCTION func_users_mealplans_delete(
	p_mealplan_id integer,
	p_created_by integer
) RETURNS SETOF typ_mealplans AS $$
	BEGIN
		-- delete saved user mealplan
		DELETE FROM 
			tbl_users_mealplans
		WHERE
			mealplan_id = p_mealplan_id
			AND created_by = p_created_by;
		
		-- return saved mealplan
		RETURN QUERY
			SELECT
				*,
				func_users_mealplans_exists(p_mealplan_id, p_created_by) AS is_favorite
			FROM
				viw_mealplans
			WHERE
				id = p_mealplan_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_mealplans_delete TO api;