class Response {
    constructor(req, res) {
        this.req = req;
        this.res = res;

        this.statusCode = '200';
        this.errorMessage = null;
        this.responseData = null;
    }

    status(statusCode) {
        this.statusCode = statusCode;
        return this;
    }

    error(errorMessage) {
        this.errorMessage = errorMessage;
        return this;
    }

    data(responseData) {
        this.responseData = responseData;
        return this;
    }

    send(data) {
        this.res.status(this.statusCode);
        this.res.json({
            status: this.statusCode,
            error: this.errorMessage,
            data: data || this.responseData
        });
    }
}

module.exports = Response;