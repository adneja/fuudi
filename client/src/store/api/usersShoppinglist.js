import axios from 'axios';
import {parseError, handleResponse} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
        usersShoppinglistGet(context) {
            return new Promise((resolve, reject) => {
                axios.get(`/users/shoppinglist/get`, {
                    headers: {
                        Authorization: context.getters.token,
                    }
                })
                .then((response) =>  {
                    handleResponse(response, resolve, reject);
                })
                .catch((err) => {
                    reject(parseError(err));
                });
            });
        },

        usersShoppinglistInsert(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/users/shoppinglist/insert`, data, {
                    headers: {
                        Authorization: context.getters.token,
                    }
                })
                .then((response) =>  {
                    handleResponse(response, resolve, reject);
                })
                .catch((err) => {
                    reject(parseError(err));
                });
            });
        },

        usersShoppinglistInsertBulk(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/users/shoppinglist/insert/bulk`, data, {
                    headers: {
                        Authorization: context.getters.token,
                    }
                })
                .then((response) =>  {
                    handleResponse(response, resolve, reject);
                })
                .catch((err) => {
                    reject(parseError(err));
                });
            });
        },

        usersShoppinglistDelete(context, data) {
            return new Promise((resolve, reject) => {
                axios.delete(`/users/shoppinglist/delete`, {
                    headers: {
                        Authorization: context.getters.token,
                    }
                })
                .then((response) =>  {
                    handleResponse(response, resolve, reject);
                })
                .catch((err) => {
                    reject(parseError(err));
                });
            });
        }
    }
}
