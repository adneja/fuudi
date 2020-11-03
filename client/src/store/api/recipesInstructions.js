import axios from 'axios';
import {parseError, handleResponse} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
        recipesInstructionsInsert(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/recipes/instructions/insert`, data, {
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

        recipesInstructionsGet(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/recipes/instructions/get/${data.id}`, {
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