import axios from 'axios';
import {parseError, handleResponse} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
		register(context, data) {
			return new Promise((resolve, reject) => {
				axios.post('/users/register', data)
				.then((response) =>  {
					handleResponse(response, resolve, reject);
				})
				.catch((err) => {
					reject(parseError(err));
				});
			});
		},

		login(context, data) {
			return new Promise((resolve, reject) => {
				axios.post(`/users/login`, data)
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