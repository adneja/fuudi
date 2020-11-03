const router = require('express').Router();
const {getQuery} = require('../utils/queryParams.js');


router.get('/query', (req, res) => {
    let params = getQuery(req.query, {
        search: ''
    });

    res.dbResponse('func_measurements_query', params);
});


module.exports = router;