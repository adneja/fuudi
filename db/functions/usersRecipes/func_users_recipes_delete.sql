CREATE OR REPLACE FUNCTION func_users_recipes_delete(
	p_recipe_id integer,
	p_created_by integer
) RETURNS SETOF typ_recipes AS $$
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
				*,
				0 AS matching_ingredients,
				func_users_recipes_exists(p_recipe_id, p_created_by) AS is_favorite
			FROM
				viw_recipes
			WHERE
				id = p_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_recipes_delete TO api;