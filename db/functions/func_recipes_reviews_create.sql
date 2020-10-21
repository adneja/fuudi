DROP FUNCTION func_recipes_ratings_create;

CREATE FUNCTION func_recipes_ratings_create (
	p_recipe_id integer,
	p_rating integer,
	p_comment text,
	p_created_by integer
) RETURNS SETOF tbl_recipes_ratings AS $$
	BEGIN
		IF NOT EXISTS(SELECT id FROM tbl_recipes WHERE id = p_recipe_id) THEN
			RAISE EXCEPTION USING HINT = 'Invalid recipe reference.';
		END IF;
		
		IF EXISTS(SELECT rating FROM tbl_recipes_ratings WHERE recipe_id = p_recipe_id AND created_by = p_created_by) THEN
			RAISE EXCEPTION USING HINT = 'You have already rated this recipe.';
		END IF;
		
		IF p_rating IS NULL THEN
			RAISE EXCEPTION USING HINT = 'Missing rating.';
		END IF;
		
		INSERT INTO tbl_recipes_ratings(
			recipe_id,
			rating,
			comment,
			created_by
		) VALUES (
			p_recipe_id,
			p_rating,
			p_comment,
			p_created_by
		);
		
		RETURN QUERY
			SELECT * FROM tbl_recipes_ratings WHERE recipe_id = p_recipe_id AND created_by = p_created_by;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_ratings_create TO api;