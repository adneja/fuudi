import Vue from 'vue';
import Vuex from 'vuex';

import general from './general.js';
import auth from './auth.js';
import recipe from './recipe.js';
import files from './files.js';

Vue.use(Vuex)

export default new Vuex.Store({
	modules: {
		general: general,
		auth: auth,
		recipe: recipe,
		files: files
	}
});