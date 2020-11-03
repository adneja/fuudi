CREATE OR REPLACE FUNCTION func_users_recipes_get(
	p_created_by integer
) RETURNS SETOF typ_recipes AS $$
	BEGIN
		RETURN QUERY
			SELECT
				r.*,
				0 AS matching_ingredients,
				func_users_recipes_exists(r.id, p_created_by) AS is_favorite
			FROM
				viw_recipes AS r
				INNER JOIN tbl_users_recipes AS ur
					ON r.id = ur.recipe_id
			WHERE
				r.created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;


GRANT EXECUTE ON FUNCTION func_users_recipes_get TO api;