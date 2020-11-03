const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


router.get('/get', authenticated, (req, res) => {
    let params = [
        req.user.id
    ];

    res.dbResponse('func_users_shoppinglist_get', params);
});


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.fooditemId,
        req.body.measurementId,
        req.body.amount,
        req.user.id
    ];

    res.dbResponse('func_users_shoppinglist_insert', params);
});


router.post('/insert/bulk', authenticated, (req, res) => {
    let params = [
        JSON.stringify(req.body.shoppinglist),
        req.user.id
    ];

    res.dbResponse('func_users_shoppinglist_insert_json', params);
});


router.post('/update', authenticated, (req, res) => {
    let params = [
        req.body.fooditemId,
        req.body.checked,
        req.user.id
    ];

    res.dbResponse('func_users_shoppinglist_update', params);
});


router.delete('/delete', authenticated, (req, res) =>  {
    let params = [
        req.user.id
    ];

    res.dbResponse('func_users_shoppinglist_delete', params);
});


module.exports = router;