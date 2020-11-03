CREATE OR REPLACE FUNCTION func_recipes_get(
	p_id integer,
	p_created_by integer DEFAULT null
) RETURNS SETOF typ_recipes AS $$
	BEGIN
		RETURN QUERY
			SELECT
				*,
				0 AS matching_ingredients,
				func_users_recipes_exists(p_id, p_created_by) AS is_favorite
			FROM
				viw_recipes
			WHERE
				id = p_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_get TO api;