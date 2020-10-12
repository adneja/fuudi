const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const auth = require('./routes/auth.js');
const recipe = require('./routes/recipe.js');
const port = process.argv[2];

const app = express();


// Middleware & routes
app.use(bodyParser.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));

app.use(auth);
app.use(recipe);


// Start server
app.listen(port, () => {
    console.log(`App is listening on port ${port}`);
});