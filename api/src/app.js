const dotenv = require('dotenv');
dotenv.config().parsed;

const path = require('path');
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const fileupload = require('express-fileupload');

const db = require('./middleware/db.js');
const response = require('./middleware/response.js');
const files = require('./routes/files.js');
const fooditems = require('./routes/fooditems.js');
const mealplans = require('./routes/mealplans.js');
const mealplansRecipes = require('./routes/mealplansRecipes.js');
const measurements = require('./routes/measurements.js');
const recipes = require('./routes/recipes.js');
const recipesIngredients = require('./routes/recipesIngredients.js');
const recipesInstructions = require('./routes/recipesInstructions.js');
const recipesRatings = require('./routes/recipesRatings.js');
const users = require('./routes/users.js');
const usersMealplans = require('./routes/usersMealplans.js');
const usersRecipes = require('./routes/usersRecipes.js');
const usersShoppinglist = require('./routes/usersShoppinglist.js');

const port = process.env.API_PORT;
const app = express();


// Middleware
app.use(bodyParser.json());
app.use(cors());
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
app.use('/api/mealplans/recipes', mealplansRecipes);
app.use('/api/measurements', measurements);
app.use('/api/recipes', recipes);
app.use('/api/recipes/ingredients', recipesIngredients);
app.use('/api/recipes/instructions', recipesInstructions);
app.use('/api/recipes/ratings', recipesRatings);
app.use('/api/users', users);
app.use('/api/users/mealplans', usersMealplans);
app.use('/api/users/recipes', usersRecipes);
app.use('/api/users/shoppinglist', usersShoppinglist);


// start
app.listen(port, () => {
    console.log(`App is listening on port ${port}`);
});