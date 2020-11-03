CREATE OR REPLACE FUNCTION func_recipes_instructions_insert(
	p_recipe_id integer,
	p_number integer,
	p_instruction text,
	p_created_by integer
) RETURNS SETOF typ_recipes_instructions AS $$
	BEGIN
		-- insert instructions
		INSERT INTO tbl_recipes_instructions (
			recipe_id,
			number,
			instruction,
			created_by
		) VALUES (	
			p_recipe_id,
			p_number,
			p_instruction,
			p_created_by
		);
			
		-- return recipe instructions
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_recipes_instructions 
			WHERE 
				recipe_id = p_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_instructions_insert TO api;