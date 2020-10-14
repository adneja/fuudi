DROP VIEW viw_recipes;

CREATE OR REPLACE VIEW viw_recipes AS
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
	f.mimetype AS file_type
FROM
	tbl_recipes AS r
	INNER JOIN tbl_users AS u
		ON r.created_by = u.id
	LEFT JOIN tbl_files AS f
		ON r.file_id = f.id;

GRANT ALL ON TABLE viw_recipes TO api;