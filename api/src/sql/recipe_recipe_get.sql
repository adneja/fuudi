SELECT
    r.*,
    (rt.created_by = $2) AS is_creator,
    (ur.created_by IS NOT NULL) AS is_bookmarked
FROM
    viw_recipes AS r
    INNER JOIN tbl_recipes AS rt
        ON r.id = rt.id
    LEFT JOIN tbl_users_recipes AS ur
        ON r.id = ur.recipe_id AND ur.created_by = $2
WHERE
    r.id = $1