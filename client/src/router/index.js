import { createRouter, createWebHistory } from 'vue-router';

import store from '../store/index.js';

import Home from '../views/Home.vue';
import RecipeBrowser from '../views/RecipeBrowser.vue';
import RecipeDetails from '../views/RecipeDetails.vue';
import RecipeCreator from '../views/RecipeCreator.vue';

const routes = [
	{
		path: '/',
		name: 'Home',
		component: RecipeBrowser,
		meta: {requiresAuth: false, showNavbar: true}
	},
	{
		path: '/recipes',
		name: 'Recipes',
		component: RecipeBrowser,
		meta: {requiresAuth: false, showNavbar: true},
	},
	{
		path: '/recipes/recipe/:id',
		name: 'Recipe',
		component: RecipeDetails,
		props: true,
		meta: {requiresAuth: false, showNavbar: true}
	},
	{
		path: '/createrecipe',
		name: 'CreateRecipe',
		component: RecipeCreator,
		meta: {requiresAuth: true, showNavbar: true}
	},
	{
		path: '/:pathMatch(.*)*',
		name: 'All',
		component: Home,
		meta: {requiresAuth: false, showNavbar: true}
	}
];


const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
	routes,
	scrollBehavior (to, from, savedPosition) {
		if (savedPosition) {
			return savedPosition
		} else {
			return { x: 0, y: 0 }
		}
	}
});


router.beforeEach((to, from, next) => {
	if(!to.meta.showNavbar) {
		store.commit('setShowNavbar', false);
	} else {
		store.commit('setShowNavbar', true);
	}

	if(to.meta.requiresAuth) {
		if(store.getters.token) {
			next();
			store.commit('setShowMobileMenu', false);
			store.commit('setShowUserMenu', false);
		} else {
			if(!from.name || from.meta.requiresAuth) {
				router.push({name: 'Home'});
			} else {
				store.commit('setShowLoginSidebar', true);
				store.commit('setLoginRedirect', to);
			}
		}
	} else {
		next();
		store.commit('setShowMobileMenu', false);
		store.commit('setShowUserMenu', false);
	}
});


export default router;
