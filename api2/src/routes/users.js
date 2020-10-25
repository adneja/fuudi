const router = require('express').Router();
const {authenticated, sign} = require('../utils/jwt.js');


// REGISTER
router.post('/insert', (req, res) => {
    let params = [
        req.body.email,
        req.body.name,
        req.body.password,
        req.body.repeatPassword
    ];

    res.dbExec('func_users_create', params)
    .then((response) => {
        res.response.status('200').data({
            user: response.rows[0],
            token: sign(response.rows[0])
        });
    })
    .catch((err) => {
        res.response.status('401').error(err.message);
    })
    .finally(() =>  {
        res.response.send();
    });
});


// LOGIN
router.get('/get/:email/:password', (req, res) => {
    let params = [
        req.params.email,
        req.params.password
    ];

    res.dbExec('func_users_get', params)
    .then((response) => {
        res.response.status('200').data({
            user: response.rows[0],
            token: sign(response.rows[0])
        });
    })
    .catch((err) => {
        res.response.status('401').error(err.message);
    })
    .finally(() => {
        res.response.send();
    });
});


// INSERT USER RECIPE (FAVORITES)
router.post('/recipes/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.user.id
    ];

    res.dbResponse('func_users_recipes_insert', params);
});


// DELETE USER RECIPE (FAVORITES)
router.delete('/recipes/delete', authenticated, (req, res) => {
    let params =  [
        req.body.recipeId,
        req.user.id
    ];

    res.dbResponse('func_users_recipes_delete', params);
});


// INSERT USER MEALPLAN (FAVORITES)
router.post('/mealplans/insert', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.user.id
    ];

    res.dbResponse('func_users_mealplans_insert', params);
});


// DELETE USER MEALPLAN (FAVORITES)
router.delete('/mealplans/delete', authenticated, (req, res) => {
    let params = [
        req.body.recipeId,
        req.user.id
    ];

    res.dbResponse('func_users_mealplans_delete', params);
});


module.exports = router;