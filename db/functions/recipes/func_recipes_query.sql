CREATE OR REPLACE FUNCTION func_recipes_query(
	p_search text DEFAULT '',
	p_cooking_time integer DEFAULT 120,
	p_ingredients_json text DEFAULT '[]',
	p_created_by integer DEFAULT null
) RETURNS SETOF typ_recipes AS $$
	BEGIN
		RETURN QUERY
			WITH ingredients AS (
				SELECT
					to_json(value)::text::int AS fooditem_id
				FROM
					json_array_elements(p_ingredients_json::json) 
			), matches AS (
				SELECT
					recipe_id,
					COUNT(fooditem_id) AS count
				FROM
					tbl_recipes_ingredients
				WHERE
					fooditem_id IN (SELECT fooditem_id FROM ingredients)
				GROUP BY
					recipe_id
			)
			
			SELECT
				r.*,
				COALESCE(m.count, 0)::integer AS ingredients_matches,
				func_users_recipes_exists(r.id, p_created_by) AS is_favorite
			FROM
				viw_recipes AS r
				LEFT JOIN matches AS m
					ON r.id = m.recipe_id
			WHERE
				(lower(r.name) || lower(r.description)) LIKE '%' || p_search || '%'
				AND r.cooking_time <= (CASE
											WHEN p_cooking_time >= 120 THEN r.cooking_time
									   		ELSE p_cooking_time
									  END)
			ORDER BY
				COALESCE(m.count, 0)::integer DESC,
				r.saves DESC,
				r.rating DESC;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_query TO api;