export default {
    state: {
        showShoppingList: false,
        shoppingList: []
    },

    getters: {
        showShoppingList(context) {
            return context.showShoppingList;
        },

        shoppingList(context) {
            return context.shoppingList;
        }
    },

    mutations: {
        setShowShoppingList(context, showShoppingList) {
            context.showShoppingList = showShoppingList;
        },

        setShoppingList(context, shoppingList) {
            context.shoppingList = shoppingList;
        }
    }
}