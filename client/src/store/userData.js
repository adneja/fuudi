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
        logout(context, currentRoute) {
            return new Promise((resolve, reject) => {
                context.commit('setToken', null);
                context.commit('setUserData', null);
    
                context.commit('setSystemMessage', {
                    content: 'Logged out.',
                    err: false
                });

                context.commit('setShoppingList', []);
    
                resolve(currentRoute.meta.requiresAuth);
            });

		}
    }
}