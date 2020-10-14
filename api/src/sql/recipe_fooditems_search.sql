SELECT
    *
FROM
    tbl_fooditems
WHERE
    LOWER(name) LIKE '%' || LOWER($1) || '%'
ORDER BY
    name ASC
LIMIT 10