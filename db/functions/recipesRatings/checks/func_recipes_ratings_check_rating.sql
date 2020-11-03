CREATE OR REPLACE FUNCTION func_recipes_ratings_check_rating(
	p_rating integer
) RETURNS boolean AS $$
	BEGIN
		IF p_rating IS NOT NULL AND (p_rating > 5 OR p_rating < 1) THEN
			RAISE EXCEPTION USING
				HINT = 'func_recipes_ratings_check_rating',
				MESSAGE = 'Rating must be from 1 to 5',
				DETAIL = 'p_rating: ' || CAST(p_rating AS text);
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_recipes_ratings_check_rating TO api;