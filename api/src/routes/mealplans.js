const router = require('express').Router();
const {authenticated, optional} = require('../utils/jwt.js');
const {getQuery} = require('../utils/queryParams.js');


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.name, 
        req.user.id
    ];

    res.dbResponse('func_mealplans_insert', params);
});


router.get('/query', optional,  (req, res) => {
    let params = getQuery(req.query, {
        search: ''
    });

    res.dbResponse('func_mealplans_query', params);
});


router.get('/get/:id', optional, (req, res) => {
    let params =  [
        req.params.id,
        req.user.id
    ];

    res.dbResponse('func_mealplans_get', params);
});


module.exports = router;