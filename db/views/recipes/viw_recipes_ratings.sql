CREATE OR REPLACE VIEW viw_recipes_ratings AS
SELECT
	r.recipe_id,
	r.rating,
	r.comment,
	r.created_by,
	u.name AS created_by_name,
	EXTRACT(epoch FROM r.created) AS created_epoch
FROM
	tbl_recipes_ratings AS r
	INNER JOIN tbl_users AS u
		ON r.created_by = u.id;
		
GRANT ALL ON TABLE viw_recipes_ratings TO api;
