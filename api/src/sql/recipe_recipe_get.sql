SELECT
    r.*,
    (rt.created_by = $2) AS is_creator
FROM
    viw_recipes AS r
    INNER JOIN tbl_recipes AS rt
        ON r.id = rt.id
WHERE
    r.id = $1