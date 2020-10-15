const router = require('express').Router();
const {jwtSignUser} = require('../util/jwt.js');
const {runQuery, queries} = require('../util/db.js');

function validateEmail(email) {
    const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
}

// Check if email is valid
router.get('/api/auth/validateemail/:email', (req, res) => {
    let params = [req.params.email];

    runQuery(queries.auth_validate_email, params, res, (result) => {
        res.json(result.rows[0]);
    });
});


// Register user
router.post('/api/auth/register', (req, res) => {
    let params = [req.body.email, req.body.name, req.body.password, req.body.repeat_password];

    if(validateEmail(req.body.email)) {
        runQuery(queries.auth_register, params, res, (result) => {
            let user = result.rows[0];
    
            res.json({
                userData: user,
                token: jwtSignUser(user)
            });
        });
    } else {
        res.json({
            error: 'Invalid email.'
        })
    }
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