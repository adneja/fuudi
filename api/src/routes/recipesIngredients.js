const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


router.get('/get/:id', (req, res) => {
    let params = [
        req.params.id
    ];

    res.dbResponse('func_recipes_ingredients_get', params);
});


router.post('/insert/bulk', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        JSON.stringify(req.body.ingredients),
        req.user.id
    ];

    res.dbResponse('func_recipes_ingredients_insert_json', params);
});


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.body.fooditemId,
        req.body.measurementId,
        req.body.amount,
        req.user.id
    ];

    res.dbResponse('func_recipes_ingredients_insert', params);
});


module.exports = router;