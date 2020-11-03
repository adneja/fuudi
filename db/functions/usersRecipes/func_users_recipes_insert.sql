CREATE OR REPLACE FUNCTION func_users_recipes_insert(
	p_recipe_id integer,
	p_created_by integer
) RETURNS SETOF typ_recipes AS $$
	BEGIN
		-- insert saved user recipe
		INSERT INTO tbl_users_recipes(
			recipe_id,
			created_by
		) VALUES (
			p_recipe_id,
			p_created_by
		);
		
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

GRANT EXECUTE ON FUNCTION func_users_recipes_insert TO api;