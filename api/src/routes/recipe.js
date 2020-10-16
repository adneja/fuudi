const router = require('express').Router();
const {verifyToken, optionalToken} = require('../util/jwt.js');
const {runQuery, queries} = require('../util/db.js');


// Search for measurements
router.get('/api/recipes/search/measurements/:search', verifyToken, (req, res) => {
    let params = [req.params.search];

    runQuery(queries.recipe_measurements_search, params, res, (result) => {
        res.json(result.rows);
    });
});


// Search for food items
router.get('/api/recipes/search/fooditems/:search', verifyToken, (req, res) => {
    let params = [req.params.search];
    
    runQuery(queries.recipe_fooditems_search, params, res, (result) => {
        res.json(result.rows);
    });
});


// Create fooditem
router.post('/api/recipes/fooditem', verifyToken, (req, res) => {
    let params = [req.body.name, req.user.id];

    runQuery(queries.recipe_fooditems_create, params, res, (result) => {
        res.json(result.rows[0]);
    });
});


// Create recipe
router.post('/api/recipes/recipe', verifyToken, (req, res) => {
    let recipeData = req.body;

    recipeData.ingredients = recipeData.ingredients.map((ingredient) => {
        return {
            fooditem_id: ingredient.foodItem.id,
            measurement_id: ingredient.measurement.id,
            amount: parseInt(ingredient.amount)
        }
    });

    recipeData.instructions = recipeData.instructions.map((instruction) => {
        return {
            number: parseInt(instruction.number),
            instruction: instruction.instruction
        }
    });

    let params = [
        recipeData.name, 
        recipeData.description, 
        parseInt(recipeData.cooking_time) || null, 
        parseInt(recipeData.portions) || null, 
        parseInt(recipeData.file_id) || null,
        
        recipeData.vegan,
        recipeData.vegetarian,
        recipeData.gluten_free,
        
        recipeData.allergen_milk,
        recipeData.allergen_egg,
        recipeData.allergen_nuts,
        recipeData.allergen_wheat,
        recipeData.allergen_soy,
        recipeData.allergen_fish,
        recipeData.allergen_shellfish,

        JSON.stringify(recipeData.ingredients), 
        JSON.stringify(recipeData.instructions), 
        req.user.id];

    runQuery(queries.recipe_recipe_create, params, res, (result) => {
        res.json(result.rows[0]);
    });
});


// Get recipes
router.get('/api/recipes/recipes/:search/:sort_order/:filters', optionalToken, (req, res) => {
    let filters = JSON.parse(req.params.filters),
        params = [
        req.params.search.trim(), 
        req.params.sort_order,
        filters.vegan,
        filters.vegetarian,
        filters.glutenFree,
        filters.milk,
        filters.egg,
        filters.nuts,
        filters.wheat,
        filters.soy,
        filters.fish,
        filters.shellfish,
        req.user.id || null
    ];

    runQuery(queries.recipe_recipes_popular, params, res, (result) => {
        res.json(result.rows);
    });
});


// Toggle bookmark
router.post('/api/recipes/recipe/bookmark', verifyToken, (req, res) => {
    let params = [req.body.id, req.user.id];

    runQuery(queries.recipe_recipe_bookmark, params, res, (result) => {
        res.json(result.rows[0].bookmarked);
    });
});


module.exports = router;