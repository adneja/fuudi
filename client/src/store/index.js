import Vue from 'vue';
import Vuex from 'vuex';
import axios from 'axios';

Vue.use(Vuex)
axios.defaults.baseURL = 'http://10.0.0.34:3333/api/';

export default new Vuex.Store({
	state: {
		userData: JSON.parse(window.localStorage.getItem('userData')) || null,
		token: window.localStorage.getItem('token') || null,
		showNavbar: true
	},

	getters: {
		userData(context) {
			return context.userData;
		},

		token(context) {
			if(context.token === 'null') {
				return null;
			}

			return context.token
		},

		showNavbar(context) {
			return context.showNavbar;
		}
	},

	mutations: {
		setUserData(context, userData) {
			context.userData = userData;
			window.localStorage.setItem('userData', JSON.stringify(userData));
		},

		setToken(context, token) {
			context.token = token;
			window.localStorage.setItem('token', token);
		},

		setShowNavbar(context, showNavbar) { 
			context.showNavbar = showNavbar;
		},
	},

	actions: {
		validateEmail(context, data) {
			return new Promise((resolve, reject) => {
				axios.get(`/auth/validateemail/${data.email}`)
				.then((response) =>  {
					resolve(response.data);
				})
				.catch((err) => {
					reject(err);
				});
			});
		},

		register(context, data) {
			return new Promise((resolve, reject) => {
				axios.post('/auth/register', data)
				.then((response) =>  {
					resolve(response.data);
				})
				.catch((err) => {
					reject(err);
				});
			});
		},

		login(context, data) {
			return new Promise((resolve, reject) => {
				axios.get(`/auth/login/${data.email}/${data.password}`)
				.then((response) =>  {
					if(response.data.error) {
						reject(response.data.error);
					} else {
						resolve(response.data);
					}
				})
				.catch((err) => {
					reject(err);
				});
			});
		},

		logout(context, data) {
			context.commit('setToken', null);
			context.commit('setUserData', null);
		},

		searchMeasurements(context, data) {
			return new Promise((resolve, reject) => {
				axios.get(`/recipes/search/measurements/${data.search}`, {
					headers: {
						authorization: context.getters.token
					}
				})
				.then((response) =>  {
					if(response.data.error) {
						reject(response.data.error);
					} else {
						resolve(response.data);
					}
				})
				.catch((err) => {
					reject(err);
				});
			});
		},

		createFoodItem(context, data) {
			return new Promise((resolve, reject) => {
				axios.post(`/recipes/fooditem`, data, {
					headers: {
						authorization: context.getters.token
					}
				})
				.then((response) =>  {
					if(response.data.error) {
						reject(response.data.error);
					} else {
						resolve(response.data);
					}
				})
				.catch((err) => {
					reject(err);
				});
			});
		},

		searchFoodItems(context, data) {
			return new Promise((resolve, reject) => {
				axios.get(`/recipes/search/fooditems/${data.search}`, {
					headers: {
						authorization: context.getters.token
					}
				})
				.then((response) =>  {
					if(response.data.error) {
						reject(response.data.error);
					} else {
						resolve(response.data);
					}
				})
				.catch((err) => {
					reject(err);
				});
			});
		}
	},

	modules: {

	}
});
