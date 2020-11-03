const router = require('express').Router();
const {authenticated, optional} = require('../utils/jwt.js');


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.mealplanId,
        req.body.recipeId,
        req.user.id
    ];

    res.dbResponse('func_mealplans_recipes_insert', params);
});


router.post('/insert/bulk', authenticated, (req, res) => {
    let params = [
        req.body.mealplanId,
        JSON.stringify(req.body.recipes),
        req.user.id
    ];

    res.dbResponse('func_mealplans_recipes_insert_json', params);
});


router.get('/get/:id', (req, res) => {
    let params =  [
        req.params.id
    ];

    res.dbResponse('func_mealplans_recipes_get', params);
});


module.exports = router;