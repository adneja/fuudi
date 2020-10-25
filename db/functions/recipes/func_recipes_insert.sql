CREATE OR REPLACE FUNCTION func_recipes_insert(
	p_name text,
	p_description text,
	p_cooking_time integer,
	p_portions integer,
	p_file_id integer,	
	p_created_by integer
) RETURNS SETOF tbl_recipes AS $$
	DECLARE
		v_new_recipe_id integer;
	BEGIN		
		-- insert recipe
		INSERT INTO tbl_recipes(
			name,
			description,
			cooking_time,
			portions,
			file_id,
			created_by
		) VALUES (
			p_name,
			p_description,
			p_cooking_time,
			p_portions,
			p_file_id,
			p_created_by
		) RETURNING id INTO v_new_recipe_id;
		
		-- return new recipe row
		RETURN QUERY
			SELECT * FROM tbl_recipes WHERE id = v_new_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_insert TO api;