CREATE OR REPLACE VIEW viw_recipes_instructions AS
SELECT
	i.id,
	i.recipe_id,
	i.number,
	i.instruction
FROM
	tbl_recipes_instructions AS i;
		
GRANT ALL ON TABLE viw_recipes_instructions TO api;