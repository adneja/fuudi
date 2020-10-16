const router = require('express').Router();
const {verifyToken} = require('../util/jwt.js');
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
router.get('/api/recipes/recipes/:search/:sort_order/:filters', (req, res) => {
    let filters = JSON.parse(req.params.filters),
        params = [
        req.params.search.trim(), 
        req.params.sort_order,
        req.params.vegan,
        req.params.vegetarian,
        req.params.glutenFree,
        req.params.milk,
        req.params.egg,
        req.params.nuts,
        req.params.wheat,
        req.params.soy,
        req.params.fish,
        req.params.shellfish
    ];


    runQuery(queries.recipe_recipes_popular, params, res, (result) => {
        res.json(result.rows);
    });
});


module.exports = router;