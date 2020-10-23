DROP VIEW viw_shoppinglist_aggregated;

CREATE OR REPLACE VIEW viw_shoppinglist_aggregated AS 
SELECT 
	fooditem_id,
	fooditem_name,
	(SUM(total_standardized)) AS total,
	standardized_measurement,
	created_by,
	checked,
	deleted
FROM 
	viw_shoppinglist
GROUP BY
	fooditem_id,
	fooditem_name,
	standardized_measurement,
	created_by,
	checked,
	deleted;
	
GRANT ALL ON TABLE viw_shoppinglist_aggregated TO api;