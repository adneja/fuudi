DROP VIEW viw_recipes;

CREATE OR REPLACE VIEW viw_recipes AS
WITH ratings AS(
	SELECT
		recipe_id,
		ROUND(AVG(rating)::numeric, 1) AS rating,
		COUNT(recipe_id) AS number_of_ratings
	FROM
		tbl_recipes_ratings
	GROUP BY
		recipe_id
)
SELECT
	r.id,
	r.name,
	r.description,
	r.cooking_time,
	r.portions,
	r.created,
	u.name AS created_by,
	f.id AS file_id,
	f.name AS file_name,
	f.mimetype AS file_type,
	ratings.rating,
	ratings.number_of_ratings
FROM
	tbl_recipes AS r
	INNER JOIN tbl_users AS u
		ON r.created_by = u.id
	LEFT JOIN tbl_files AS f
		ON r.file_id = f.id
	LEFT JOIN ratings
		ON r.id = ratings.recipe_id;

GRANT ALL ON TABLE viw_recipes TO api;