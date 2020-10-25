<template>
	<div id="app">
		<Topbar v-if="$store.getters.showNavbar"></Topbar>

		<transition name="slideIn">
			<Login v-if="$store.getters.showLoginSidebar"></Login>
		</transition>

		<transition name="slideIn">
			<MobileMenu v-if="$store.getters.showMobileMenu"></MobileMenu>
		</transition>

		<transition name="slideIn">
			<UserMenu v-if="$store.getters.showUserMenu"></UserMenu>
		</transition>

		<transition name="slideIn">
			<ShoppingList v-if="$store.getters.showShoppingList"></ShoppingList>
		</transition>

		<transition name="slideDown">
            <SystemMessage v-show="$store.getters.systemMessage"></SystemMessage>
        </transition>

		<!--
		<transition name="fadeIn">
			<router-view/>
		</transition>
		-->

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
	import Login from './components/Login.vue';
	import MobileMenu from './components/MobileMenu.vue';
	import UserMenu from './components/UserMenu.vue';
	import ShoppingList from './components/ShoppingList.vue';

	export default {
		name: 'app',

		components: {
			Topbar,
			SystemMessage,
			Login,
			MobileMenu,
			UserMenu,
			ShoppingList
		},

		mounted() {
			if(this.$store.getters.token) {
				this.$store.dispatch('getShoppingList')
				.then((response) => {
					this.$store.commit('setShoppingList', response);
				})
				.catch((err) => {
					console.log(err);
				});
			}
		}
	}
</script>

<style lang="less" scoped>
	@import "./assets/global.less";

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
