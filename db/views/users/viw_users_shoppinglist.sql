drop view viw_users_shoppinglist;

CREATE OR REPLACE VIEW viw_users_shoppinglist AS
WITH cte AS (
	SELECT
		s.fooditem_id,
		f.name AS fooditem_name,
		(s.amount * m.standardized) AS amount,
		mt.standardized_measurement,
		s.created_by,
		s.checked
	FROM
		tbl_users_shoppinglist AS s
		INNER JOIN tbl_fooditems AS f
			ON s.fooditem_id = f.id
		INNER JOIN tbl_measurements AS m
			ON s.measurement_id = m.id
		INNER JOIN tbl_measurements_types AS mt	
			ON m.type_id = mt.id
)

SELECT
	fooditem_id,
	fooditem_name,
	SUM(amount)::int AS amount,
	standardized_measurement,
	created_by,
	checked
FROM
	cte
GROUP BY	
	fooditem_id,
	fooditem_name,
	standardized_measurement,
	created_by,
	checked
ORDER BY
	fooditem_name ASC;

		
GRANT ALL ON TABLE viw_users_shoppinglist TO api;