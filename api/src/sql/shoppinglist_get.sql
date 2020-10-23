SELECT
    *
FROM
    viw_shoppinglist_aggregated
WHERE
    created_by = $1
    AND deleted IS NULL
ORDER BY
    fooditem_name ASC