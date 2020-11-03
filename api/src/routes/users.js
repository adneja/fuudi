const router = require('express').Router();
const {sign} = require('../utils/jwt.js');


router.post('/register', (req, res) => {
    let params = [
        req.body.email,
        req.body.name,
        req.body.password,
        req.body.repeatPassword
    ];

    console.log(params);

    res.dbExec('func_users_create', params)
    .then((response) => {
        res.response.status('200').data({
            user: response.rows[0],
            token: sign(response.rows[0])
        });
    })
    .catch((err) => {
        res.response.status('401').error(err.message);
    })
    .finally(() =>  {
        res.response.send();
    });
});


router.post('/login', (req, res) => {
    let params = [
        req.body.email,
        req.body.password
    ];

    res.dbExec('func_users_get', params)
    .then((response) => {
        res.response.status('200').data({
            user: response.rows[0],
            token: sign(response.rows[0])
        });
    })
    .catch((err) => {
        res.response.status('401').error(err.message);
    })
    .finally(() => {
        res.response.send();
    });
});


module.exports = router;
