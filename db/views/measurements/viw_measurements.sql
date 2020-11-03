CREATE OR REPLACE VIEW viw_measurements AS
SELECT
	id,
	name,
	long_name
FROM
	tbl_measurements;