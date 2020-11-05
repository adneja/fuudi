CREATE OR REPLACE FUNCTION func_recipes_instructions_insert_json(
	p_recipe_id integer,
	p_instructions_json text,
	p_created_by integer
) RETURNS SETOF typ_recipes_instructions AS $$
	BEGIN
		-- insert instructions
		INSERT INTO tbl_recipes_instructions(
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

GRANT EXECUTE ON FUNCTION func_mealplans_recipes_insert_json TO api;