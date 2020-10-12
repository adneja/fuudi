export default {
    state: {
        showNavbar: true,
        systemMessage: null
    },

    getters: {
		showNavbar(context) {
			return context.showNavbar;
        },
        
        systemMessage(context) {
            return context.systemMessage;
        }
    },

    mutations: {
		setShowNavbar(context, showNavbar) { 
			context.showNavbar = showNavbar;
        },
        
        setSystemMessage(context, systemMessage) {
            context.systemMessage = systemMessage;
        }
    }
};