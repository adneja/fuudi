CREATE OR REPLACE VIEW viw_recipes_ingredients AS
SELECT
	r.id AS recipe_id,
	f.id AS fooditem_id,
	f.name AS fooditem_name,
	m.id AS measurement_id,
	m.name AS measurement_name,
	i.amount
FROM
	tbl_recipes_ingredients AS i
	INNER JOIN tbl_measurements AS m
		ON i.measurement_id = m.id
	INNER JOIN tbl_fooditems AS f
		ON i.fooditem_id = f.id
	INNER JOIN tbl_recipes AS r
		ON i.recipe_id = r.id;
		
GRANT ALL ON TABLE viw_recipes_ingredients TO api;
