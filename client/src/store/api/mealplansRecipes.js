import axios from 'axios';
import {parseError, handleResponse} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
        mealplansRecipesGet(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/mealplans/recipes/get/${data.id}`, data, {
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

        mealplansRecipesInsert(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/mealplans/recipes/insert`, data, {
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