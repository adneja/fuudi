import axios from 'axios';

axios.defaults.baseURL = `${process.env.VUE_APP_REST_ADDR}/api/`;

export default {
    actions: {
        uploadFile(context, formData) {
            return new Promise((resolve, reject) => {
                axios.post('/files/file', formData, {
                    headers: {
                        authorization: context.getters.token,
                        'Content-Type': 'multipart/form-data'
                    }
                })
                .then((response) =>  {
                    if(response.data.error) {
                        reject(response.data.error);
                    } else {
                        resolve(response.data);
                    }
                })
                .catch((err) => {
                    reject(err);
                });
            });
        },

        getFile(context, data) {
            return new Promise((resolve, reject) => {
                axios.get(`/files/file/${data.filePath}`, {
                    headers: {
                        authorization: context.getters.token
                    }
                })
                .then((response) =>  {
                    if(response.data.error) {
                        reject(response.data.error);
                    } else {
                        resolve(response.data);
                    }
                })
                .catch((err) => {
                    reject(err);
                });
            });
        }
    }
};