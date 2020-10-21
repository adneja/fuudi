DROP VIEW viw_recipes_ratings;

CREATE VIEW viw_recipes_ratings AS
SELECT
	r.*,
	EXTRACT(epoch FROM r.created) AS created_epoch,
	u.name AS author
FROM
	tbl_recipes_ratings AS r
	INNER JOIN tbl_users AS u
		ON r.created_by = u.id;
		
GRANT ALL ON TABLE viw_recipes_ratings TO api;