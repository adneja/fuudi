DROP FUNCTION func_recipes_create;

CREATE FUNCTION func_recipes_create(
	p_name text,
	p_description text,
	p_created_by integer
)
RETURNS SETOF tbl_recipes
LANGUAGE plpgsql
AS $$
	DECLARE
		v_new_recipe_id integer;
	BEGIN
		INSERT INTO tbl_recipes(
			name,
			description,
			created_by
		) VALUES (
			p_name,
			p_description,
			p_created_by
		) RETURNING id INTO v_new_recipe_id;
		
		RETURN QUERY
			SELECT * FROM tbl_recipe WHERE id = v_new_recipe_id;
	END;
$$;

GRANT EXECUTE ON FUNCTION func_recipes_create TO api;