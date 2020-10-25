const router = require('express').Router();
const {authenticated} = require('../utils/jwt.js');


// INSERT FOODITEW
router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.params.search,
        req.user.id
    ];

    res.dbResponse('func_fooditems_insert', params);
});


// QUERY FOODITEMS
router.get('/query/:search', (req, res) => {
    let params = [
        req.params.search
    ];

    res.dbResponse('func_fooditems_query', params);
});


module.exports = router;