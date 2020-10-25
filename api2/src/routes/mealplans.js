const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


// INSERT MEALPLAN
router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.name, 
        req.user.id
    ];

    res.dbResponse('func_mealplans_insert', params);
});


// QUERY MEALPLANS
router.get('/query/:search/:sortOrder/:ingredients', (req, res) => {
    let params = [
        req.body.search, 
        req.body.searchOrder, 
        req.body.ingredients
    ];

    res.dbResponse('func_mealplans_query', params);
});


// GET MEALPLAN
router.get('/get/:id', (req, res) => {
    let params =  [
        req.params.id
    ];

    res.dbResponse('func_mealplans_get', params);
});


// INSERT MEALPLAN RECIPES
router.post('/recipes/insert', (req, res) => {
    let params = [
        req.body.mealplanId,
        req.body.recipes,
        req.user.id
    ];

    res.dbResponse('func_mealplans_recipes_insert', params);
});


// GET MEALPLAN RECIPES
router.get('/recipes/get/:id', (req, res) => {
    let params =  [
        req.params.id
    ];

    res.dbResponse('func_mealplans_recipes_get', params);
});


module.exports = router;