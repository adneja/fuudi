CREATE OR REPLACE VIEW viw_files AS
SELECT
	id,
	name,
	size,
	mimetype
FROM
	tbl_files;