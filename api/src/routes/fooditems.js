const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');
const {getQuery} = require('../utils/queryParams.js');


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.name,
        req.user.id
    ]

    res.dbResponse('func_fooditems_insert', params);
});


router.get('/query', (req, res) => {
    let params = getQuery(req.query, {
        search: ''
    });

    res.dbResponse('func_fooditems_query', params);
});


module.exports = router;