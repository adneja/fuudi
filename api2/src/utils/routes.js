const fs = require('fs');

function getRouters() {

}

module.exports =  {
    setup(app) {
        routers.forEach((router) => {
            app.use(router);
        });
    }
};