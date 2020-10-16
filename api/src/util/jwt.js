const jwt = require('jsonwebtoken');

module.exports = {
    // Create session token
    jwtSignUser: (user) => {
        const ONE_WEEK = 60 * 60 * 24 * 7;

        return jwt.sign(user, process.env.JWT_SECRET, {
            expiresIn: ONE_WEEK
        });
    },

    // Verify session token
    verifyToken: (req, res, next) => {
        const token = req.header('authorization');

        if(!token) {
            res.json({
                error: 'This action requires authentication'
            });
        } else {
            try {
                const verified = jwt.verify(token, process.env.JWT_SECRET);
                req.user = verified;
                next();
            } catch (err) {
                res.json({
                    error: 'This action requires authentication'
                });
            }
        }
    },

    // Get user data if valid token, proceed if not
    optionalToken: (req, res, next) => {
        const token = req.header('authorization');

        if(token) {
            try {
                const verified = jwt.verify(token, process.env.JWT_SECRET);
                req.user = verified;
                next();
            } catch (err) {
                req.user = {};
                next();
            }
        } else {
            next();
        }
    }
};