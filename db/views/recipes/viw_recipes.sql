DROP VIEW viw_recipes;

CREATE VIEW viw_recipes AS
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
), num_of_ingredients AS (
	SELECT
		i.recipe_id,
		COUNT(i.fooditem_id) AS num_of_ingredients
	FROM
		tbl_recipes_ingredients AS i
	GROUP BY
		i.recipe_id
)

SELECT
	r.id,
	r.name,
	r.description,
	r.cooking_time,
	r.portions,
	f.id AS file_id,
	f.mimetype AS file_mimetype,
	r.created_by,
	u.name AS created_by_name,
	EXTRACT(epoch FROM r.created)::integer AS created_epoch,
	COALESCE(ratings.rating, 0)::float AS rating,
	COALESCE(ratings.number_of_ratings, 0)::integer AS number_of_ratings,
	COALESCE(saves.saves, 0)::integer AS saves
FROM
	tbl_recipes AS r
	INNER JOIN tbl_users AS u
		ON r.created_by = u.id
	LEFT JOIN tbl_files AS f
		ON r.file_id = f.id
	LEFT JOIN ratings
		ON r.id = ratings.recipe_id
	LEFT JOIN saves
		ON r.id = saves.recipe_id
	LEFT JOIN num_of_ingredients
		ON r.id = num_of_ingredients.recipe_id;

GRANT ALL ON TABLE viw_recipes TO api;