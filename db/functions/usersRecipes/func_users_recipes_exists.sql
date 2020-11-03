CREATE FUNCTION func_users_recipes_exists(
	p_recipe_id integer,
	p_created_by integer DEFAULT null
) RETURNS boolean AS $$
	BEGIN
		RETURN EXISTS(SELECT recipe_id FROM tbl_users_recipes WHERE recipe_id = p_recipe_id AND created_by = p_created_by);
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_recipes_exists TO api;