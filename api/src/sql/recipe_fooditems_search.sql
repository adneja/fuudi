SELECT
    *
FROM
    tbl_fooditems
WHERE
    LOWER(name) LIKE '%' || LOWER($1) || '%'