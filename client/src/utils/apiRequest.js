export function queryString(query) {
    let queryString = '?';

    Object.keys(query).forEach((field) => {
        queryString += `${field}=${query[field]}&`;
    });

    return queryString;
}

export function handleResponse(response, resolve, reject) {
    if(response.data.error) {
        reject(response.data.error);
    } else {
        resolve(response.data.data);
    }
}

export function parseError(error) {
    switch(error.response.status) {
        case 401:
            return 'Login required';
    }
}
