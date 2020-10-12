import Vue from 'vue';
import VueRouter from 'vue-router';

import store from '../store/index.js';

import Home from '../views/Home.vue';
import SignIn from '../views/SignIn.vue';
import Register from '../views/Register.vue';
import Logout from '../views/Logout.vue';
import ResetPassword from '../views/ResetPassword.vue';
import Plans from '../views/Plans.vue';
import Recipes from '../views/Recipes.vue';
import CreatePlan from '../views/CreatePlan.vue';
import CreateRecipe from '../views/CreateRecipe.vue';

Vue.use(VueRouter)

const routes = [
	{
		path: '/',
		name: 'Home',
		component: Home,
		meta: {requiresAuth: false, showNavbar: true}
	},
	{
		path: '/signin',
		name: 'SignIn',
		component: SignIn,
		meta: {requiresAuth: false, showNavbar: false}
	},
	{
		path: '/register',
		name: 'Register',
		component: Register,
		meta: {requiresAuth: false, showNavbar: false}
	},
	{
		path: '/logout',
		name: 'Logout',
		component: Logout,
		meta: {requiresAuth: true, showNavbar: false}
	},
	{
		path: '/resetpassword',
		name: 'ResetPassword',
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
		meta: {requiresAuth: false, showNavbar: true}
	},
	{
		path: '/createplan',
		name: 'CreatePlan',
		component: CreatePlan,
		meta: {requiresAuth: true, showNavbar: true}
	},
	{
		path: '/createrecipe',
		name: 'CreateRecipe',
		component: CreateRecipe,
		meta: {requiresAuth: true, showNavbar: true}
	},
	{
		path: '/*',
		name: 'All',
		component: Home,
		meta: {requiresAuth: false, showNavbar: true}
	}
];


const router = new VueRouter({
	mode: 'history',
	base: process.env.BASE_URL,
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
		} else {
			if(!from.name || from.meta.requiresAuth) {
				router.push({name: 'Home'});
			} else {
				store.commit('setSystemMessage', {
					content: 'Please login to use this feature.',
					error: true
				});
			}
		}
	} else {
		next();
	}
});


export default router;
