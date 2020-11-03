import axios from 'axios';
import {parseError, handleResponse} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
        recipesRatingsInsert(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/recipes/ratings/insert`, data, {
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

        recipesRatingsGet(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/recipes/ratings/get/${data.id}`, data, {
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