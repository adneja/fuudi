import axios from 'axios';
import {parseError, handleResponse, queryString} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
        usersRecipesInsert(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/users/recipes/insert`, data, {
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

        usersRecipesDelete(context, data) {
            console.log(data);
            return new Promise((resolve, reject) => {
                axios.delete(`/users/recipes/delete/${data.recipeId}`, {
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
