CREATE OR REPLACE VIEW viw_shoppinglist AS 
SELECT
	l.*,
	f.name AS fooditem_name,
	m.name AS measurement_name,
	m.standardized AS measurement_standardized,
	mt.id AS measurement_type_id,
	mt.name AS measurement_type_name,
	mt.standardized_measurement,
	(l.amount * m.standardized) AS total_standardized
FROM
	tbl_shoppinglist AS l
	INNER JOIN tbl_fooditems AS f
		ON l.fooditem_id = f.id
	INNER JOIN tbl_measurements AS m
		ON l.measurement_id = m.id
	INNER JOIN tbl_measurements_types AS mt
		ON m.type_id = mt.id;
	
GRANT ALL ON TABLE viw_shoppinglist TO api;