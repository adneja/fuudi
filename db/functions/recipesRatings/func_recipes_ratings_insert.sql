CREATE OR REPLACE FUNCTION func_recipes_ratings_insert (
	p_recipe_id integer,
	p_rating integer,
	p_comment text,
	p_created_by integer
) RETURNS SETOF typ_recipes_ratings AS $$
	BEGIN		
		-- insert ratings
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
		
		-- return recipe ratings
		RETURN QUERY
			SELECT 
				* 
			FROM 
				viw_recipes_ratings 
			WHERE 
				recipe_id = p_recipe_id;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_ratings_insert TO api;