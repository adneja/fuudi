import axios from 'axios';
import {parseError, handleResponse, queryString} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
        measurementsQuery(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/measurements/query/${queryString(data)}`, {
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