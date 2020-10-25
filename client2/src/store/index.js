import Vuex from 'vuex';

import general from './general.js';
import auth from './auth.js';
import recipe from './recipe.js';
import files from './files.js';
import shoppingList from './shoppingList.js';
import mealplans from './mealplans.js';

export default Vuex.createStore({
	modules: {
		general: general,
		auth: auth,
		recipe: recipe,
		files: files,
		shoppingList: shoppingList,
		mealplans: mealplans
	}
});