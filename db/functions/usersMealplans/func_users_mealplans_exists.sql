CREATE OR REPLACE FUNCTION func_users_mealplans_exists(
	p_mealplan_id integer,
	p_created_by integer DEFAULT null
) RETURNS boolean AS $$
	BEGIN
		RETURN EXISTS(SELECT mealplan_id FROM tbl_users_mealplans WHERE mealplan_id = p_mealplan_id AND created_by = p_created_by);
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_users_mealplans_exists TO api;