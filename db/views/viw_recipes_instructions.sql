CREATE VIEW viw_recipes_instructions AS
SELECT
	i.id,
	i.recipe_id,
	r.name AS recipe_name,
	i.number,
	i.instruction,
	u.name AS created_by
FROM
	tbl_recipes_instructions AS i
	INNER JOIN tbl_recipes AS r
		ON i.recipe_id = r.id
	INNER JOIN tbl_users AS u
		ON i.created_by = u.id;
		
GRANT ALL ON TABLE viw_recipes_instructions TO api;