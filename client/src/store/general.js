export default {
    state: {
        showNavbar: true,
        systemMessage: null,
        showMobileMenu: false,
        showUserMenu: false,
        showLoginSidebar: false,
        loginRedirect: null
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
        },

        showLoginSidebar(context) {
            return context.showLoginSidebar;
        },

        loginRedirect(context) {
            return context.loginRedirect;
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
        },

        setShowLoginSidebar(context, showLoginSidebar) {
            context.showLoginSidebar = showLoginSidebar;
        },

        setLoginRedirect(context, loginRedirect) {
            context.loginRedirect = loginRedirect;
        }
    }
};