const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fileupload = require('express-fileupload');
const path = require('path');
const dotenv = require('dotenv');

const auth = require('./routes/auth.js');
const recipe = require('./routes/recipe.js');
const file = require('./routes/file.js');
const shoppinglist = require('./routes/shoppinglist.js');

const port = process.env.API_PORT;
const app = express();

dotenv.config().parsed;

// Middleware
app.use(bodyParser.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(fileupload({
    limits: { fileSize: 50 * 1024 * 1024 }
}));

// static
app.use('/api/files/img', express.static(path.join(__dirname, '../files/img')));
app.use('/api/files/thumb', express.static(path.join(__dirname, '../files/thumb')));

// routes
app.use(auth);
app.use(recipe);
app.use(file);
app.use(shoppinglist);

app.listen(port, () => {
    console.log(`App is listening on port ${port}`);
});