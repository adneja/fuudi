CREATE OR REPLACE FUNCTION func_shoppinglist_check_amount(
	p_amount integer
) RETURNS boolean AS $$
	BEGIN
		IF p_amount IS NOT NULL AND NOT p_amount > 0 THEN
			RAISE EXCEPTION USING
				HINT = 'func_shoppinglist_check_amount',
				MESSAGE = 'Amount cannot be 0',
				DETAIL = 'p_amount: ' || CAST(p_amount AS text);
		END IF;
		
		RETURN true;
	END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION func_shoppinglist_check_amount TO api;