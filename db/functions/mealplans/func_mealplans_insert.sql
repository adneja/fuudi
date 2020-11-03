CREATE OR REPLACE FUNCTION func_mealplans_insert(
	p_name text,
	p_created_by integer
) RETURNS SETOF typ_mealplans AS $$
	DECLARE
		v_new_mealplan_id integer;
	BEGIN
		-- insert mealplan
		INSERT INTO tbl_mealplans(
			name,
			created_by
		) VALUES (
			p_name,
			p_created_by
		) RETURNING id INTO v_new_mealplan_id;
		
		-- add to creators favorites
		INSERT INTO tbl_users_mealplans(
			mealplan_id,
			created_by
		) VALUES (
			v_new_mealplan_id,
			p_created_by
		);
		
		-- return new plan
		RETURN QUERY
			SELECT 
				*,
				false AS is_favorite
			FROM 
				viw_mealplans 
			WHERE 
				id = v_new_mealplan_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_mealplans_insert TO api;