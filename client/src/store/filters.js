export default {
    state: {
        searchWord: window.localStorage.getItem('recipes-filter-search') || '',
        showFavorites: window.localStorage.getItem('recipes-filter-favorites') == 'true' || false,
        ingredients: JSON.parse(window.localStorage.getItem('recipes-filter-ingredients')) || [],
        cookingTime: parseInt(window.localStorage.getItem('recipes-filter-cookingtime')) || 120,
        searching: false
    },

    getters: {
        searchWord(context) {
            return context.searchWord;
        },

        showFavorites(context) {
            return context.showFavorites;
        },

        ingredients(context) {
            return context.ingredients;
        },

        cookingTime(context) {
            return context.cookingTime;
        },

        numAppliedFilters(context) {
            let num = 0;
            
            num += context.showFavorites ? 1 : 0;
            num += context.cookingTime < 120 ? 1 : 0;
            num += context.ingredients.length;

            return num;
        },

        searching(context) {
            return context.searching;
        }
    },

    mutations: {
        setSearchWord(context, searchWord) {
            context.searchWord = searchWord;
            window.localStorage.setItem('recipes-filter-search', searchWord);
        },

        setShowFavorites(context, showFavorites) {
            context.showFavorites = showFavorites;
            window.localStorage.setItem('recipes-filter-favorites', showFavorites);
        },

        setIngredients(context, ingredients) {
            context.ingredients = ingredients;
            window.localStorage.setItem('recipes-filter-ingredients', JSON.stringify(ingredients));
        },

        addIngredient(context, ingredient) {
            context.ingredients.push(ingredient);
            window.localStorage.setItem('recipes-filter-ingredients', JSON.stringify(context.ingredients));
        },

        removeIngredient(context, ingredient) {
            context.ingredients = context.ingredients.filter(i => i.id !== ingredient.id);
            window.localStorage.setItem('recipes-filter-ingredients', JSON.stringify(context.ingredients));
        },

        setCookingTime(context, cookingTime) {
            context.cookingTime = cookingTime;
            window.localStorage.setItem('recipes-filter-cookingtime', cookingTime);
        },

        setSearching(context, searching) {
            context.searching = searching;
        }
    },

    actions: {
        clearFilters(context) {
            context.commit('setSearchWord', '');
            context.commit('setShowFavorites', false);
            context.commit('setIngredients', []);
            context.commit('setCookingTime', 120);
        }
    }
}