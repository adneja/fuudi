export default {
    state: {
        showNavbar: true
    },

    getters: {
		showNavbar(context) {
			return context.showNavbar;
		}
    },

    mutations: {
		setShowNavbar(context, showNavbar) { 
			context.showNavbar = showNavbar;
		}
    }
};