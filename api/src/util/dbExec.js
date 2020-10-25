const {Pool} = require('pg');
const dotenv = require('dotenv');
dotenv.config().parsed;

const config = {
    user: process.env.SQL_USER,
    host: process.env.SQL_SERVER,
    database: process.env.SQL_DB,
    password: process.env.SQL_PASSWORD,
    port: process.env.SQL_PORT
};

const pool = new Pool(config);


module.exports = (req, res, next) => {
    req.dbExec = (functionName, params) => {
        let query = `SELECT * FROM ${functionName}(${params.map((p, i) => `$${index+1}`)})`;
        
        return new Promise((resolve, reject) => {
            pool.query(query, params, (err, result) => {
                if(err) {
                    reject(err);
                } else {
                    resolve(result.rows);
                }
            });
        });
    };

    next();
}
