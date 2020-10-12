import axios from 'axios';

axios.defaults.baseURL = 'http://10.0.0.34:3333/api/';

export default {
    state: {
		userData: JSON.parse(window.localStorage.getItem('userData')) || null,
        token: window.localStorage.getItem('token') || null
    },

    getters: {
		userData(context) {
            if(context.userData === 'null') {
                return null;
            }

			return context.userData;
		},

		token(context) {
			if(context.token === 'null') {
				return null;
			}

			return context.token
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
		}
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
		}
    }
};