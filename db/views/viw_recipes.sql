DROP VIEW viw_recipes;

CREATE OR REPLACE VIEW viw_recipes AS
WITH ratings AS (
	SELECT
		recipe_id,
		ROUND(AVG(rating)::numeric, 1) AS rating,
		COUNT(recipe_id) AS number_of_ratings
	FROM
		tbl_recipes_ratings
	GROUP BY
		recipe_id
), saves AS (
	SELECT
		recipe_id,
		COUNT(recipe_id) AS saves
	FROM
		tbl_users_recipes AS ur
	GROUP BY
		recipe_id
)

SELECT
	r.id,
	r.name,
	r.description,
	r.cooking_time,
	r.portions,
	r.vegan,
	r.vegetarian,
	r.gluten_free,
	r.allergen_milk,
	r.allergen_egg,
	r.allergen_nuts,
	r.allergen_wheat,
	r.allergen_soy,
	r.allergen_fish,
	r.allergen_shellfish,
	r.created,
	EXTRACT(epoch FROM r.created) AS created_epoch,
	u.name AS created_by,
	f.id AS file_id,
	f.name AS file_name,
	f.mimetype AS file_type,
	COALESCE(ratings.rating, 0)::float AS rating,
	COALESCE(ratings.number_of_ratings, 0)::float AS number_of_ratings,
	COALESCE(saves.saves, 0)::float AS saves
FROM
	tbl_recipes AS r
	INNER JOIN tbl_users AS u
		ON r.created_by = u.id
	LEFT JOIN tbl_files AS f
		ON r.file_id = f.id
	LEFT JOIN ratings
		ON r.id = ratings.recipe_id
	LEFT JOIN saves
		ON r.id = saves.recipe_id;

GRANT ALL ON TABLE viw_recipes TO api;