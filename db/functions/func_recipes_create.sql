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
		IF p_name IS NULL OR CHAR_LENGTH(p_name) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing name.';
		END IF;
		
		IF p_description IS NULL OR CHAR_LENGTH(p_description) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing description.';
		END IF;
		
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
			SELECT * FROM tbl_recipes WHERE id = v_new_recipe_id;
	END;
$$;

GRANT EXECUTE ON FUNCTION func_recipes_create TO api;