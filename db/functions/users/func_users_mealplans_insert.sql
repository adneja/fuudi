CREATE OR REPLACE FUNCTION func_users_mealplans_insert(
	p_recipe_id integer,
	p_created_by integer
) RETURNS SETOF tbl_users_mealplans AS $$
	BEGIN
		-- insert saved user mealplan
		INSERT INTO tbl_users_mealplans(
			recipe_id,
			created_by
		) VALUES (
			p_recipe_id,
			p_created_by
		);
		
		-- return saved mealplan
		RETURN QUERY
			SELECT
				*
			FROM
				tbl_users_mealplans
			WHERE
				recipe_id = p_recipe_id
				AND created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_mealplans_insert TO api;