const router = require('express').Router();
const {verifyToken} = require('../util/jwt.js');
const {runQuery, queries} = require('../util/db.js');


// Add items to shopping list
router.post('/api/shoppinglist/add', verifyToken, (req, res) => {
    let params = [req.body.items, req.user.id];

    runQuery(queries.shoppinglist_add, params, res, (result) => {
        res.json(result.rows);
    });
});


// Get users shopping list
router.get('/api/shoppinglist', verifyToken, (req, res) => {
    let params = [req.user.id];

    runQuery(queries.shoppinglist_get, params, res, (result) => {
        res.json(result.rows);
    });
});


// Delete items from shopping list
router.post('/api/shoppinglist/delete', verifyToken, (req, res) => {
    let params = [req.body.all, req.user.id];

    console.log(params);

    runQuery(queries.shoppinglist_delete, params, res, (result) => {
        res.json(result.rows);
    });
});

// Check item in shopping list
router.post('/api/shoppinglist/check', verifyToken, (req, res) => {
    let params = [req.body.check, req.body.fooditem_id, req.user.id];

    runQuery(queries.shoppinglist_check, params, res, (result) => {
        res.json(result.rows);
    });
});

module.exports = router;