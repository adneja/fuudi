const router = require('express').Router();
const { RSA_NO_PADDING } = require('constants');
const path = require('path');
const {authenticated} = require('../utils/jwt.js');


// UPLOAD FILE
router.post('/upload', authenticated, (req, res) => {
    let file = req.files.file,
        params = [
            file.name, 
            file.size, 
            file.mimetype, 
            req.user.id
        ];

    res.dbExec('func_files_insert', params)
    .then((response) => {
        let fileData = response.rows[0],
            filePath = `${fileData.id.toString()}.${fileData.mimetype.split('/')[1]}`;
        
        file.mv(path.join(__dirname, '../../files/img', filePath))
        .then((response) => {
            res.response.status('200').send({
                id: fileData.id,
                path: filePath
            });
        })
        .catch((err) =>  {
            res.response.status('500').error(err.message).send();
        });
    })
    .catch((err) => {
        res.response.status('200').error(err.message).send();
    });
});


module.exports = router;