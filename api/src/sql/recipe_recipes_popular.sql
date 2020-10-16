SELECT 
    * 
FROM 
    viw_recipes AS r
WHERE
    -- search
    LOWER(name) LIKE '%' || LOWER($1) || '%'
    OR LOWER(description) LIKE '%' || LOWER($1) || '%'

    -- filters
    AND (r.vegan = $3 OR $3 = false)
    AND (r.vegetarian = $4 OR $4 = false)
    AND (r.gluten_free = $5 OR $5 = false)
    AND (r.allergen_milk = $6 OR $6 = false)
    AND (r.allergen_egg = $7 OR $7 = false)
    AND (r.allergen_nuts = $8 OR $8 = false)
    AND (r.allergen_wheat = $9 OR $9 = false)
    AND (r.allergen_soy = $10 OR $10 = false)
    AND (r.allergen_fish = $11 OR $11 = false)
    AND (r.allergen_shellfish = $12 OR $12 = false)

-- sort order
ORDER BY
    (CASE
        WHEN $2 = 'rating' THEN r.rating
        WHEN $2 = 'new' THEN EXTRACT(epoch FROM r.created) 
        ELSE r.saves
    END) DESC