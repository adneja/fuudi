module.exports = {
    getQuery(queryObject, config) {
        let params = [];

        Object.keys(config).forEach((param) => {
            if(queryObject[param]) {
                params.push(queryObject[param]);
            } else {
                params.push(config[param]);
            }
        });

        return params;
    }
};