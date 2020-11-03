class Param {
    constructor(req, res) {
        this.req = req;
        this.res = res;
        this.params = [];
    }

    validate(config, callback) {
        try {
            Object.keys(config).forEach((param) => {
                if(req.body[param]) {
                    switch(config[param]) {
                        case Number:
                            try {
                                this.params.push(parseInt(param));
                            } catch(err) {
                                throw `${param} must be a number`;
                            }

                            return;

                        case String:
                            this.params.push(param);
                            return;
                        case Array:
                            try {
                                let obj = JSON.parse(param);

                                if(Array.isArray(obj)) {
                                    this.params.push(param);
                                } else {
                                    throw `${param} must be an array`;
                                }
                            } catch(err) {
                                throw `${param} must be an array`;
                            }

                            return;

                        case Object:
                            try {
                                let obj = JSON.parse(param);
                            } catch(err) {
                                if(!Array.isArray(obj)) {
                                    this.params.push(param);
                                } else {
                                    throw `${param} must be an object`;
                                }
                            }

                            return;
                    }
                } else {
                    throw `Param: (${param}) is missing` 
                }
            });

            callback(null, this.params);
        } catch(err) {
            callback(err, null);
        }
    }
}