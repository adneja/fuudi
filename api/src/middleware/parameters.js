const Param = require('../classes/Param.js');

module.exports = (req, res, next) => {
    res.parameters = new Param(req, res);
    next();
};