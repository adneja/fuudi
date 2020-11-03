const router = require('express').Router();
const {authenticated, optional} = require('../utils/jwt.js');


router.get('/get/:id', optional, (req, res) => {
    let params = [
        req.params.id
    ];

    res.dbResponse('func_recipes_ratings_get', params);
});


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.body.rating,
        req.body.comment,
        req.user.id
    ];

    res.dbResponse('func_recipes_ratings_insert', params);
});


module.exports = router;