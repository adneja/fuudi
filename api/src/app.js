const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fileupload = require('express-fileupload');
const path = require('path');

// routers
const auth = require('./routes/auth.js');
const recipe = require('./routes/recipe.js');
const file = require('./routes/file.js');

const port = process.argv[2];
const app = express();


// Middleware & routes
app.use(bodyParser.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(fileupload({
    limits: { fileSize: 50 * 1024 * 1024 }
}));


app.use('/api/files/img', express.static(path.join(__dirname, '../files/img')));
app.use('/api/files/thumb', express.static(path.join(__dirname, '../files/thumb')));
app.use(auth);
app.use(recipe);
app.use(file);


// Start server
app.listen(port, () => {
    console.log(`App is listening on port ${port}`);
});