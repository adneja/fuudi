const router = require('express').Router();


// QUERY MEASUREMENTS
router.get('/query/:search', (req, res) => {
    let params = [
        req.params.search
    ];

    res.dbresponse('func_measurements_query', params);
});


module.exports = router;