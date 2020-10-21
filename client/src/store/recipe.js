import axios from 'axios';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api/`;

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
                axios.get(`/recipes/recipes/${data.search || ' '}/${data.sort_order}/${data.diatary_constraints}/${data.allergens}/${data.max_cooking_time}/${data.ingredients}`, {
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
		
		bookmark(context, data) {
			return new Promise((resolve, reject) => {
				axios.post(`/recipes/recipe/bookmark`, data, {
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

		getRecipe(context, data) {
			return new Promise((resolve, reject) => {
                axios.get(`/recipes/recipe/${data.id}`, {
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

		getRecipeIngredients(context, data) {
			return new Promise((resolve, reject) => {
                axios.get(`/recipes/recipe/ingredients/${data.id}`)
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

		getRecipeInstructions(context, data) {
			return new Promise((resolve, reject) => {
                axios.get(`/recipes/recipe/instructions/${data.id}`)
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