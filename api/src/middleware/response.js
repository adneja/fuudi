const Response = require('../classes/Response.js');

module.exports = (req, res, next) => {
    res.response = new Response(req, res);
    next();
};