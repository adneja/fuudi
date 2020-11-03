CREATE OR REPLACE FUNCTION func_users_shoppinglist_insert(
	p_fooditem_id integer,
	p_measurement_id integer,
	p_amount integer,
	p_created_by integer
) RETURNS SETOF typ_users_shoppinglist AS $$
	BEGIN
		INSERT INTO tbl_users_shoppinglist(
			fooditem_id,
			measurement_id,
			amount,
			created_by
		) VALUES (
			p_fooditem_id,
			p_measurement_id,
			p_amount,
			p_created_by
		);
		
		RETURN QUERY
			SELECT
				*
			FROM
				viw_users_shoppinglist;
	END;
$$ LANGUAGE plpgsql;


GRANT EXECUTE ON FUNCTION func_users_shoppinglist_insert TO api;