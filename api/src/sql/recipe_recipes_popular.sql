SELECT 
    r.*,
    (CASE WHEN ur.created_by IS NULL THEN false ELSE true END) AS bookmarked
FROM 
    viw_recipes AS r
    LEFT JOIN tbl_users_recipes AS ur
        ON r.id = ur.recipe_id AND ur.created_by = $13
WHERE
    -- search
    (LOWER(name) LIKE '%' || LOWER($1) || '%'
    OR LOWER(description) LIKE '%' || LOWER($1) || '%')

    -- filters
    AND (r.vegan = $3 OR $3 = false)
    AND (r.vegetarian = $4 OR $4 = false)
    AND (r.gluten_free = $5 OR $5 = false)

    AND (r.allergen_milk = false AND $6 = true OR $6 = false)
    AND (r.allergen_egg = false AND $7 = true OR $7 = false)
    AND (r.allergen_nuts = false AND $8 = true OR $8 = false)
    AND (r.allergen_wheat = false AND $9 = true OR $9 = false)
    AND (r.allergen_soy = false AND $10 = true OR $10 = false)
    AND (r.allergen_fish = false AND $11 = true OR $11 = false)
    AND (r.allergen_shellfish = false AND $12 = true  OR $12 = false)

-- sort order
ORDER BY
    (CASE
        WHEN $2 = 'rating' THEN r.rating
        WHEN $2 = 'new' THEN EXTRACT(epoch FROM r.created) 
        ELSE r.saves
    END) DESC