const router = require('express').Router();
const {authenticated, optional} = require('../utils/jwt.js');
const {getQuery} = require('../utils/queryParams.js');


router.post('/insert', authenticated, (req, res) => {
    let params = [
        req.body.name, 
        req.body.description,
        req.body.cookingTime,
        req.body.portions,
        req.body.fileId,
        req.user.id
    ];
    
    res.dbResponse('func_recipes_insert', params);
});


router.get('/query', optional, (req, res) => {
    let params = getQuery(req.query, {
        search: '',
        cookingTime: 120,
        ingredients: '[]',
    });

    console.log(params);

    res.dbResponse('func_recipes_query', params);
});


router.get('/get/:id', optional, (req, res) => {
    let params = [
        req.params.id,
        req.user.id
    ];

    res.dbResponse('func_recipes_get', params);
});


module.exports = router;