const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


router.get('/get/:id', (req, res) => {
    let params = [
        req.params.id
    ];

    res.dbResponse('func_recipes_instructions_get', params);
});


router.post('/insert/bulk', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        JSON.stringify(req.body.instructions),
        req.user.id
    ];

    res.dbResponse('func_recipes_instructions_insert_json', params);
});


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.body.number,
        req.body.instruction,
        req.user.id
    ];

    res.dbResponse('func_recipes_instructions_insert', params);
});


module.exports = router;