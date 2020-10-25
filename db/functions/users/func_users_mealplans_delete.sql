CREATE OR REPLACE FUNCTION func_users_mealplans_delete(
	p_recipe_id integer,
	p_created_by integer
) RETURNS SETOF tbl_users_mealplans AS $$
	BEGIN
		-- delete saved user mealplan
		DELETE FROM 
			tbl_users_mealplans
		WHERE
			recipe_id = p_recipe_id
			AND created_by = p_created_by;
		
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

GRANT EXECUTE ON FUNCTION func_users_mealplans_delete TO api;