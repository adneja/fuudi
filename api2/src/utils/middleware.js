let middlewares = [];

module.exports =  {
    setup(app) {
        middlewares.forEach((middleware) => {
            app.use(middleware);
        });
    }
};