DROP VIEW viw_recipes_ingredients;

CREATE OR REPLACE VIEW viw_recipes_ingredients AS
SELECT
	r.id AS recipe_id,
	r.name AS recipe_name,
	f.id AS fooditem_id,
	f.name AS fooditem_name,
	m.id AS measurement_id,
	m.name AS measurement_name,
	m.long_name AS measurement_long_name,
	m.standardized,
	mt.name,
	mt.standardized_measurement,
	i.amount,
	i.created,
	u.name AS created_by
FROM
	tbl_recipes_ingredients AS i
	INNER JOIN tbl_measurements AS m
		ON i.measurement_id = m.id
	INNER JOIN tbl_fooditems AS f
		ON i.fooditem_id = f.id
	INNER JOIN tbl_recipes AS r
		ON i.recipe_id = r.id
	INNER JOIN tbl_users AS u
		ON i.created_by = u.id
	INNER JOIN tbl_measurements_types AS mt
		ON m.type_id = mt.id;
		
GRANT ALL ON TABLE viw_recipes_ingredients TO api;


