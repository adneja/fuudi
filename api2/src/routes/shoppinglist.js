const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


// INSERT SHOPPINGLIST ITEMS
router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.items, 
        req.user.id
    ];

    res.dbResponse('func_shoppinglist_insert', params);
});


// GET SHOPPINGLIST ITEMS
router.get('/get', authenticated, (req, res) => {
    let params = [
        req.params.id
    ];

    res.dbResponse('func_shoppinglist_get', params);
});


// DELETE SHOPPINGLIST ITEMS
router.delete('/delete', authenticated, (req, res) => {
    let params = [
        req.body.all, 
        req.user.id
    ];

    res.dbResponse('func_shoppinglist_delete', params);
});


// UPDATE SHOPPINGLIST ITEM
router.post('/update', authenticated, (req, res) => {
    let params = [
        req.body.check,
        req.body.fooditemId,
        req.user.id
    ];

    res.dbResponse('func_shoppinglist_update', params);
});


module.exports = router;