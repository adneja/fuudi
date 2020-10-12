SELECT
    *
FROM
    tbl_measurements
WHERE
    LOWER(name) LIKE '%' || LOWER($1) || '%'
    OR LOWER(long_name) LIKE '%' || LOWER($1) || '%'