CREATE OR REPLACE FUNCTION func_users_shoppinglist_insert_json(
	p_shoppinglist_json text,
	p_created_by integer
) RETURNS SETOF typ_users_shoppinglist AS $$
	BEGIN
		INSERT INTO tbl_users_shoppinglist(
			fooditem_id,
			measurement_id,
			amount,
			created_by
		) 
		SELECT
			s.fooditem_id,
			s.measurement_id,
			s.amount,
			p_created_by
		FROM
			json_to_recordset(p_shoppinglist_json::json) AS s (
				fooditem_id integer,
				measurement_id integer,
				amount integer
			);
			
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist
			WHERE
				created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_shoppinglist_insert_json TO api;