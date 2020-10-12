DROP FUNCTION func_fooditems_create;

CREATE FUNCTION func_fooditems_create(
	p_name text,
	p_created_by integer
)
RETURNS SETOF tbl_fooditems
LANGUAGE plpgsql
AS $$
	DECLARE
		v_new_fooditem_id integer;
	BEGIN
		INSERT INTO tbl_fooditems(
			name,
			created_by
		) VALUES (
			p_name,
			p_created_by
		) RETURNING
			id INTO v_new_fooditem_id;
			
		RETURN QUERY
			SELECT * FROM tbl_fooditems WHERE id = v_new_fooditem_id;
	END;
$$;

GRANT EXECUTE ON FUNCTION func_fooditems_create TO api;