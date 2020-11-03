<template>
	<div id="app">
		<Topbar v-if="$store.getters.showNavbar"></Topbar>

		<transition name="slideIn">
			<LoginSidebar v-if="$store.getters.showLoginSidebar"></LoginSidebar>
		</transition>

		<transition name="slideIn">
			<MobileMenu v-if="$store.getters.showMobileMenu"></MobileMenu>
		</transition>

		<transition name="slideIn">
			<UserMenu v-if="$store.getters.showUserMenu"></UserMenu>
		</transition>

		<ShoppingList></ShoppingList>

		<transition name="slideDown">
            <SystemMessage v-show="$store.getters.systemMessage"></SystemMessage>
        </transition>

		<router-view v-slot="{Component}">
			<transition name="fadeIn" mode="out-in">
				<component v-bind:is="Component"></component>
			</transition>
		</router-view>
	</div>
</template>

<script>
	import Topbar from './components/Topbar.vue';
	import SystemMessage from './components/SystemMessage.vue';
	import LoginSidebar from './components/LoginSidebar.vue';
	import MobileMenu from './components/MobileMenu.vue';
	import UserMenu from './components/UserMenu.vue';
	import ShoppingList from './components/SidePanels/Shoppinglist.vue';

	export default {
		name: 'app',

		components: {
			Topbar,
			SystemMessage,
			LoginSidebar,
			MobileMenu,
			UserMenu,
			ShoppingList
		}
	}
</script>

<style lang="less" scoped>
	@import "./assets/styles/custom.less";

	#app {
		height: 100%;
		font-family: 'Staatliches', cursive;
		font-size: 13pt;
		letter-spacing: 0.04rem;
	}

	.slideDown-enter-active, .slideDown-leave-active {
        transition: all 0.3s;
    }

    .slideDown-enter-from, .slideDown-leave-to {
		margin-top: -50px;
	}
	
	.slideIn-enter-active, .slideIn-leave-active {
		transition: margin 0.3s;
	}

	.slideIn-enter-from, .slideIn-leave-to {
        margin-right: -500px;
	}

	.fadeIn-enter-active, .fadeIn-leave-active {
		transition: opacity 0.2s;
	}

	.fadeIn-enter-from, .fadeIn-leave-to {
		opacity: 0;
	}
</style>
