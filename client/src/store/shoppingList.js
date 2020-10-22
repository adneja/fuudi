export default {
    state: {
        shoppingList: JSON.parse(window.localStorage.getItem('shopping-list')) || [],
        newlyAddedShoppingListItems: [],
        showShoppingList: false
    },

    getters: {
        shoppingList(context) {
            return context.shoppingList;
        },

        showShoppingList(context) {
            return context.showShoppingList;
        },

        newlyAddedShoppingListItems(context) {
            return context.newlyAddedShoppingListItems;
        }
    },  

    mutations: {
        addShoppingListItem(context, item) {
            context.shoppingList.push(item);
            window.localStorage.setItem('shopping-list', JSON.stringify(context.shoppingList));
        },

        addShoppingListItems(context, items) {
            context.shoppingList.push(...items);
            context.newlyAddedShoppingListItems = items;
            context.showShoppingList = true;
            window.localStorage.setItem('shopping-list', JSON.stringify(context.shoppingList));
        },

        removeShoppingListItem(context, item) {
            let index = context.shoppingList.indexOf(item);

            context.shoppingList.splice(index, 1);
            window.localStorage.setItem('shopping-list', JSON.stringify(context.shoppingList));
        },

        removeCheckedShoppingListItems(context) {
            window.localStorage.setItem('shopping-list', JSON.stringify(context.shoppingList));
        },

        removeAllShoppingListItems(context) {
            context.shoppingList = [];
            window.localStorage.setItem('shopping-list', JSON.stringify(context.shoppingList));
        },

        setShowShoppingList(context, showShoppingList) {
            context.showShoppingList = showShoppingList;

            if(!showShoppingList) {
                context.newlyAddedShoppingListItems = [];
            }
        }
    }
};