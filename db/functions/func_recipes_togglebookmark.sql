DROP FUNCTION func_recipes_togglebookmark;

CREATE FUNCTION func_recipes_togglebookmark(
	p_recipe_id integer,
	p_created_by integer
) RETURNS boolean AS $$
	DECLARE
		v_bookmarked boolean;
	BEGIN
		IF EXISTS(SELECT from tbl_users_recipes WHERE recipe_id = p_recipe_id AND created_by = p_created_by) THEN
			DELETE FROM 
				tbl_users_recipes 
			WHERE 
				recipe_id = p_recipe_id 
				AND created_by = p_created_by;
				
			v_bookmarked := false;
		ELSE
			INSERT INTO tbl_users_recipes (
				recipe_id,
				created_by
			) VALUES (
				p_recipe_id,
				p_created_by
			);
			
			v_bookmarked := true;
		END IF;
		
		RETURN v_bookmarked;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_togglebookmark TO api;


