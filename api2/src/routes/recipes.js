const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


// INSERT RECIPE
router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.name, 
        req.body.description,
        req.body.cookingTime,
        req.body.portions,
        req.body.fileId,
        req.user.id
    ];
    
    res.dbResponse('func_recipes_insert', params);
});


// QUERY RECIPES
router.get('/query/:search/:sortOrder/:cookingTime/:ingredients', (req, res) => {
    let params = [
        req.params.search,
        req.params.sortOrder,
        req.params.cookingTime,
        req.params.ingredients
    ];

    res.dbResponse('func_recipes_query', params);
});


// GET RECIPE
router.get('/get/:id', (req, res) => {
    let params = [
        req.params.id
    ];

    res.dbResponse('func_recipes_get', params);
});


// GET RECIPE INGREDIENTS
router.get('/ingredients/get/:id', (req, res) => {
    let params = [
        req.params.id
    ];

    res.dbResponse('func_recipes_ingredients_get', params);
});


// INSERT RECIPE INGREDIENTS
router.post('/ingredients/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.body.ingredients,
        req.user.id
    ];

    res.dbResponse('func_recipes_ingredients_insert', params);
});


// GET RECIPE INSTRUCTIONS
router.get('/instructions/get/:id', (req, res) => {
    let params = [
        req.params.id
    ];

    res.dbResponse('func_recipes_instructions_get', params);
});


// INSERT RECIPE INSTRUCTIONS
router.post('/instructions/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.body.instructions,
        req.user.id
    ];

    res.dbResponse('func_recipes_instructions_insert', params);
});


// GET RECIPE RATINGS
router.get('/ratings/get/:id', (req, res) => {
    let params = [
        req.params.id
    ];

    res.dbResponse('func_recipes_ratings_get', params);
});


// INSERT RECIPE RATING
router.post('/ratings/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.body.rating,
        req.body.comment,
        req.user.id
    ];

    res.dbResponse('func_recipes_ratings_insert', params);
});


module.exports = router;