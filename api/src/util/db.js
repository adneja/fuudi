const {Pool} = require('pg');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config().parsed;

const dbConfig = {
    user: process.env.sql_user,
    host: process.env.sql_server,
    database: process.env.sql_db,
    password: process.env.sql_password,
    port: process.env.sql_port
};

const pool = new Pool(dbConfig);

let queries = {},
    filenames = fs.readdirSync(path.join(__dirname, '../sql'));

filenames.forEach((filename) => {
    queries[filename.split('.')[0]] = fs.readFileSync(path.join(__dirname, '../sql/', filename), 'utf-8');
});

module.exports = {
    pool: pool,

    runQuery: (query, params, res, callback) => {
        pool.query(query, params, (err, result) => {
            if(err) {
                if(err.hint) {
                    res.json({
                        error: err.hint
                    });
                } else {
                    res.json({
                        error: 'Internal server error.'
                    });
                    console.log(err);
                }
            } else {
                callback(result);
            }
        });
    },

    queries: queries
};