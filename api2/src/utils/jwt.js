const jwt = require('jsonwebtoken');


module.exports = {
    sign: (user) => {
        const ONE_WEEK = 60 * 60 * 24 * 7;

        return jwt.sign(user, process.env.JWT_SECRET, {
            expiresIn: ONE_WEEK
        });
    },

    authenticated: (req, res, next) => {
        const token = req.header('Authorization');

        if(token) {
            try {
                const verified = jwt.verify(token, process.env.JWT_SECRET);
                req.user = verified;
                next();
            } catch (err) {
                req.user = {id: null};
                next();
            }
        } else {
            next();
        }
    }
};