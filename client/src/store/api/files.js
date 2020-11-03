import axios from 'axios';
import {parseError, handleResponse} from '../../utils/apiRequest.js';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api`;

export default {
    actions: {
        filesUpload(context, formData) {
            return new Promise((resolve, reject) => {
                axios.post('/files/upload', formData, {
                    headers: {
                        Authorization: context.getters.token,
                        'Content-Type': 'multipart/form-data'
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