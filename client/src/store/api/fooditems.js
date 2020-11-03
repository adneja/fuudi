import axios from 'axios';
import {parseError, handleResponse, queryString} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
        fooditemsQuery(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/fooditems/query/${queryString(data)}`, {
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

        fooditemsInsert(context, data) {
            return new Promise((resolve, reject) => {
                axios.post(`/insert`, data, {
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