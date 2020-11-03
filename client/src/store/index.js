import Vuex from 'vuex';

import filters from './filters.js';
import general from './general.js';
import shoppinglist from './shoppinglist.js';
import userData from './userData.js';

import files from './api/files.js';
import fooditems from './api/fooditems.js';
import mealplans from './api/mealplans.js';
import mealplansRecipes from './api/mealplansRecipes.js';
import measurements from './api/measurements.js';
import recipes from './api/recipes.js';
import recipesIngredients from './api/recipesIngredients.js';
import recipesInstructions from './api/recipesInstructions.js';
import recipesRatings from './api/recipesRatings.js';
import users from './api/users.js';
import usersMealplans from './api/usersMealplans.js';
import usersRecipes from './api/usersRecipes.js';
import usersShoppinglist from './api/usersShoppinglist.js';




export default Vuex.createStore({
	modules: {
		filters: filters,
		general: general,
		shoppinglist: shoppinglist,
		userData: userData,
		files: files,
		fooditems: fooditems,
		mealplans: mealplans,
		mealplansRecipes: mealplansRecipes,
		measurements: measurements,
		recipes: recipes,
		recipesIngredients: recipesIngredients,
		recipesInstructions: recipesInstructions,
		recipesRatings: recipesRatings,
		users: users,
		usersMealplans: usersMealplans,
		usersRecipes: usersRecipes,
		usersShoppinglist: usersShoppinglist
	}
});