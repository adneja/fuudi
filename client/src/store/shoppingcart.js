export default {
    state: {
        shoppingCart = JSON.parse(window.localStorage.getItem('shoppingCart')) || []
    },

    getters: {
        shoppingCart(context) {
            return context.shoppingCart;
        }
    },  

    mutations: {
        addShoppingCartItem(context, item) {
            context.shoppingCart.push(item);
            window.localStorage.setItem(JSON.stringify(context.shoppingCart));
        },

        removeShoppingCartItem(context, item) {
            let index = context.shoppingCart.indexOf(item);

            context.shoppingCart.splice(index, 1);
            window.localStorage.setItem(JSON.stringify(context.shoppingCart));
        }
    }
};