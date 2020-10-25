CREATE OR REPLACE FUNCTION func_users_recipes_delete(
	p_recipe_id integer,
	p_created_by integer
) RETURNS SETOF tbl_users_recipes AS $$
	BEGIN
		-- insert saved user recipe
		DELETE FROM 
			tbl_users_recipes
		WHERE
			recipe_id = p_recipe_id
			AND created_by = p_created_by;
		
		-- return saved recipe
		RETURN QUERY
			SELECT
				*
			FROM
				tbl_users_recipes
			WHERE
				recipe_id = p_recipe_id
				AND created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_recipes_delete TO api;