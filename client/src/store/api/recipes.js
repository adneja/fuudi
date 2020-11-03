import axios from 'axios';
import {parseError, handleResponse, queryString} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api/`;

export default {
    actions: {
        recipesInsert(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/recipes/insert`, data, {
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

        recipesGet(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/recipes/get/${data.id}`, {
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

        recipesQuery(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/recipes/query/${queryString(data)}`, {
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
};