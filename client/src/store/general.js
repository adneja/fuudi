export default {
    state: {
        showNavbar: true,
        systemMessage: null,
        showMobileMenu: false,
        showUserMenu: false,
    },

    getters: {
		showNavbar(context) {
			return context.showNavbar;
        },
        
        systemMessage(context) {
            return context.systemMessage;
        },

        showMobileMenu(context) {
            return context.showMobileMenu;
        },

        showUserMenu(context) {
            return context.showUserMenu;
        }
    },

    mutations: {
		setShowNavbar(context, showNavbar) { 
			context.showNavbar = showNavbar;
        },
        
        setSystemMessage(context, systemMessage) {
            context.systemMessage = systemMessage;
        },

        setShowMobileMenu(context, showMobileMenu) {
            context.showMobileMenu = showMobileMenu;
        },

        setShowUserMenu(context, showUserMenu) {
            context.showUserMenu = showUserMenu;
        }
    }
};