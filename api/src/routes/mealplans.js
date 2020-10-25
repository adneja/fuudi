const router = require('express').Router();
const {verifyToken, optionalToken} = require('../util/jwt.js');
const {runQuery, queries} = require('../util/db.js');


// create mealplan
router.post('/api/mealplans/create', verifyToken, (req, res) => {
    let params = [req.body.name, req.body.recipes, req.user.id];

    runQuery(queries.mealplan_create, params, res, (result) => {
        res.json(result.rows);
    });
});


module.exports = router;