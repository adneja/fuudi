import axios from 'axios';

axios.defaults.baseURL = 'http://10.0.0.34:3333/api/';

export default {
    actions: {
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
        },
        
        createRecipe(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/recipes/recipe`, data, {
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

        getRecipes(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/recipes/recipes/${data.search || ' '}/${data.sort_order}/${data.filters}`, {
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