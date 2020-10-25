DROP VIEW viw_users;

CREATE VIEW viw_users AS
SELECT
	id,
	email,
	name
FROM
	tbl_users;
	
	
GRANT ALL ON TABLE viw_users TO api;