SELECT
    r.*,
    (CASE
        WHEN r.created_by = $2 THEN true
        ELSE false
    END) AS my_rating
FROM
    viw_recipes_ratings AS r
WHERE
    recipe_id = $1