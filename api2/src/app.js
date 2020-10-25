const dotenv = require('dotenv');
dotenv.config().parsed;

const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');
const fileupload = require('express-fileupload');

const db = require('./middleware/db.js');
const response = require('./middleware/response.js');
const files = require('./routes/files.js');
const fooditems = require('./routes/fooditems.js');
const mealplans = require('./routes/mealplans.js');
const measurements = require('./routes/measurements.js');
const recipes = require('./routes/recipes.js');
const shoppinglist = require('./routes/shoppinglist.js');
const users = require('./routes/users.js');

const port = process.env.API_PORT;
const app = express();

// Middleware
app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));
app.use(fileupload({
    limits: { fileSize: 50 * 1024 * 1024 }
}));
app.use(response);
app.use(db);

// static
app.use('/api/files/img', express.static(path.join(__dirname, '../files/img')));
app.use('/api/files/thumb', express.static(path.join(__dirname, '../files/thumb')));

// routes
app.use('/api/files', files);
app.use('/api/fooditems', fooditems);
app.use('/api/mealplans', mealplans);
app.use('/api/measurements', measurements);
app.use('/api/recipes', recipes);
app.use('/api/shoppinglsit', shoppinglist);
app.use('/api/users', users);


// start
app.listen(port, () => {
    console.log(`App is listening on port ${port}`);
});