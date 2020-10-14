const router = require('express').Router();
const {verifyToken} = require('../util/jwt.js');
const {runQuery, queries} = require('../util/db.js');
const path = require('path');


// upload file
router.post('/api/files/file/', verifyToken, (req, res) => {
    let file = req.files.file,
        params = [file.name, file.size, file.mimetype, req.user.id];

    // new row in db
    runQuery(queries.file_file_create, params, res, (result) => {
        let fileRow = result.rows[0],
            filePath = `${fileRow.id.toString()}.${fileRow.mimetype.split('/')[1]}`;

        // write file to /files directory
        file.mv(path.join(__dirname, '../../files/img', filePath))
        .then(() => {
            res.json({
                id: fileRow.id,
                path: filePath
            });
        })
        .catch((err) => {
            console.log(err);
            res.json({
                error: err
            });
        });
    });
});

module.exports = router;