const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.user.id
    ];

    res.dbResponse('func_users_recipes_insert', params);
});


router.get('/get', authenticated, (req, res) => {
    let params = [
        req.user.id
    ];

    res.dbResponse('func_users_recipes_get', params);
});


router.delete('/delete/:id', authenticated, (req, res) => {
    let params = [
        req.params.id,
        req.user.id
    ];

    res.dbResponse('func_users_recipes_delete', params);
});


module.exports = router;