CREATE OR REPLACE FUNCTION func_users_mealplans_insert(
	p_mealplan_id integer,
	p_created_by integer
) RETURNS SETOF typ_mealplans AS $$
	BEGIN
		-- insert saved user mealplan
		INSERT INTO tbl_users_mealplans(
			mealplan_id,
			created_by
		) VALUES (
			p_mealplan_id,
			p_created_by
		);
		
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

GRANT EXECUTE ON FUNCTION func_users_mealplans_insert TO api;