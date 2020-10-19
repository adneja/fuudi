import { createRouter, createWebHistory } from 'vue-router';

import store from '../store/index.js';

import Home from '../views/Home.vue';
import ResetPassword from '../views/ResetPassword.vue';
import Plans from '../views/Plans.vue';
import Recipes from '../views/Recipes.vue';
import Recipe from '../views/Recipe.vue';
import Ratings from '../views/Ratings.vue';
import CreatePlan from '../views/CreatePlan.vue';
import CreateRecipe from '../views/CreateRecipe.vue';

const routes = [
	{
		path: '/',
		name: 'Home',
		component: Recipes,
		meta: {requiresAuth: false, showNavbar: true}
	},
	{
		path: '/resetpassword',
		name: 'Reset Password',
		component: ResetPassword,
		meta: {requiresAuth: false, showNavbar: false}
	},
	{
		path: '/plans',
		name: 'Plans',
		component: Plans,
		meta: {requiresAuth: false, showNavbar: true}
	},
	{
		path: '/recipes',
		name: 'Recipes',
		component: Recipes,
		meta: {requiresAuth: false, showNavbar: true},
	},
	{
		path: '/recipes/recipe/:id',
		component: Recipe,
		props: true,
		meta: {requiresAuth: false, showNavbar: true}
	},
	{
		path: '/ratings',
		name: 'Ratings',
		component: Ratings,
		meta: {requiresAuth: false, showNavbar: true}
	},
	{
		path: '/createplan',
		name: 'Create Plan',
		component: CreatePlan,
		meta: {requiresAuth: true, showNavbar: true}
	},
	{
		path: '/createrecipe',
		name: 'Create Recipe',
		component: CreateRecipe,
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
    routes
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
