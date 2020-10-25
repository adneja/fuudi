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
    res.dbResponse = (dbFunctionName, params) => {
        let query = `SELECT * FROM ${dbFunctionName}(${params.map((p, i) => `$${i+1}`).join(',')})`;
        
        pool.query(query, params, (err, result) => {
            if(err) {
                res.response.status('500').error(err.message).send();
            } else {
                res.response.status('200').send(result.rows);
            }

            res.send();
        });
    };

    res.dbExec = (dbFunctionName, params) => {
        let query = `SELECT * FROM ${dbFunctionName}(${params.map((p, i) => `$${i+1}`).join(',')})`;

        return new Promise((resolve, reject) => {
            pool.query(query, params, (err, result) => {
                if(err) {
                    reject(err);
                } else {
                    resolve(result);
                }
            });
        });
    };

    next();
};
