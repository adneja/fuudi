const router = require('express').Router();
const {verifyToken} = require('../util/jwt.js');
const {runQuery, queries, query} = require('../util/db.js');


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

    console.log(recipeData);

    let params = [recipeData.name, recipeData.description, parseInt(recipeData.cooking_time), parseInt(recipeData.portions), JSON.stringify(recipeData.ingredients), JSON.stringify(recipeData.instructions), req.user.id];
    console.log(params);

    runQuery(queries.recipe_recipe_create, params, res, (result) => {
        console.log(result.rows);
        res.json(result.rows[0]);
    });
});


// Get popular recipes
router.get('/api/recipes/recipes', verifyToken, (req, res) => {
    runQuery(queries.recipe_recipes_popular.sql, params, res, (result) => {
        res.json(result.rows);
    });
});


module.exports = router;