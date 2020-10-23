import Axios from "axios";

import axios from 'axios';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api/`;

export default {
    state: {
        shoppingList: JSON.parse(window.localStorage.getItem('shopping-list')) || [],
        showShoppingList: false
    },

    getters: {
        shoppingList(context) {
            return context.shoppingList;
        },

        showShoppingList(context) {
            return context.showShoppingList;
        },
    },  

    mutations: {
        setShoppingList(context, data) {
            context.shoppingList = data;
        }, 
        
        checkShoppingListItem(context, data) {

        },

        checkAllShoppingListItems(context, data) {

        },

        setShowShoppingList(context, showShoppingList) {
            context.showShoppingList = showShoppingList;

            if(!showShoppingList) {
                context.newlyAddedShoppingListItems = [];
            }
        }
    },

    actions: {
        addShoppingListItems(context, data) {
            return new Promise((resolve, reject) => {
                axios.post('/shoppinglist/add', data, {
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

        getShoppingList(context) {
            return new Promise((resolve, reject) => {
                axios.get('/shoppinglist', {
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

        deleteShoppingList(context, data) {
            return new Promise((resolve, reject) => {
                axios.post('/shoppinglist/delete', {all: data.all}, {
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

        checkShoppingListItem(context, data) {
            return new Promise((resolve, reject) => {
                axios.post('/shoppinglist/check', data, {
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
    },
};