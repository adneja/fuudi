import axios from 'axios';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api/`;

export default {
    actions: {
        createMealplan(context, data) {
            return new Promise((resolve, reject) => {
                axios.post('/mealplans/create', data, {
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
    }
};