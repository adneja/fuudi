import axios from 'axios';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api/`;

export default {
    state: {
		userData: JSON.parse(window.localStorage.getItem('userData')) || null,
        token: window.localStorage.getItem('token') || null,
        showLoginSidebar: false,
        loginRedirect: null
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
        },

        showLoginSidebar(context) {
            return context.showLoginSidebar;
        },

        loginRedirect(context) {
            return context.loginRedirect;
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
        
        setShowLoginSidebar(context, showLoginSidebar) {
            context.showLoginSidebar = showLoginSidebar;
        },

        setLoginRedirect(context, loginRedirect) {
            context.loginRedirect = loginRedirect;
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

		logout(context, currentRoute) {
            return new Promise((resolve, reject) => {
                context.commit('setToken', null);
                context.commit('setUserData', null);
    
                context.commit('setSystemMessage', {
                    content: 'Logged out.',
                    err: false
                });
    
                resolve(currentRoute.meta.requiresAuth);
            });

		}
    }
};