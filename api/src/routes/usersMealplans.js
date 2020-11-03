const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.mealplanId,
        req.user.id
    ];

    res.dbResponse('func_users_mealplans_insert', params);
});


router.get('/get', authenticated, (req, res) => {
    let params = [
        req.user.id
    ];

    res.dbResponse('func_users_mealplans_get', params);
});


router.delete('/delete/:id', authenticated, (req, res) => {
    let params = [
        req.params.id,
        req.user.id
    ];

    res.dbResponse('func_users_mealplans_delete', params);
});


module.exports = router;