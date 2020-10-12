const router = require('express').Router();
const {jwtSignUser} = require('../util/jwt.js');
const {runQuery, queries} = require('../util/db.js');


// Check if email is valid
router.get('/api/auth/validemail/:email', (req, res) => {
    let params = [req.params.email];

    runQuery(queries.auth_validate_email, params, res, (result) => {
        res.json(result.rows[0]);
    });
});


// Register user
router.post('/api/auth/register', (req, res) => {
    let params = [req.body.email, req.body.name, req.body.password];
    
    runQuery(queries.auth_register, params, res, (result) => {
        let user = result.rows[0];

        res.json({
            userData: user,
            token: jwtSignUser(user)
        });
    });
});


// Login user
router.get('/api/auth/login/:email/:password', (req, res) => {
    let params = [req.params.email, req.params.password];

    runQuery(queries.auth_login, params, res, (result) => {
        let user = result.rows[0];

        res.json({
            userData: user,
            token: jwtSignUser(user)
        });
    });
});


module.exports = router;