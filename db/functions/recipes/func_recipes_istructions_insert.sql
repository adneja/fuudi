CREATE OR REPLACE FUNCTION func_recipes_istructions_insert(
	p_recipe_id integer,
	p_instructions_json text,
	p_created_by integer
) RETURNS SETOF tbl_recipes_ingredients AS $$
	BEGIN
		-- insert instructions
		INSERT INTO tbl_recipes_instructions (
			recipe_id,
			number,
			instruction,
			created_by
		)
		SELECT
			p_recipe_id,
			i.number,
			i.instruction,
			p_created_by
		FROM
			json_to_recordset(p_instructions_json::json) AS i (
				number integer,
				instruction text
			);
			
		-- return inserted rows
		RETURN QUERY
			SELECT * FROM tbl_recipes_instructions WHERE recipe_id = p_recipe_id AND created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_istructions_insert TO api;