<template>
	<div id="app">
		<Topbar v-if="$store.getters.showNavbar"></Topbar>

		<transition name="slideDown">
            <SystemMessage v-show="$store.getters.systemMessage"></SystemMessage>
        </transition>

		<keep-alive>
			<router-view/>
		</keep-alive>

		<Footer></Footer>
	</div>
</template>

<script>
	import Topbar from './components/Topbar.vue';
	import Footer from './components/Footer.vue';
	import SystemMessage from './components/SystemMessage.vue';

	export default {
		name: 'app',
		components: {
			Topbar,
			SystemMessage
		}
	}
</script>

<style lang="less" scoped>
	@import "./assets/global.less";

	#app {
		font-family: 'Ubuntu', sans-serif;
		height: 100%;
		font-family: 'Fugaz One', cursive;
		font-family: 'Sansita Swashed', cursive;
		font-family: 'Bebas Neue', cursive;
		font-family: 'Staatliches', cursive;
		font-size: 13pt;
		letter-spacing: 0.08rem;
		background: url(./assets/background.png);
	background-attachment: fixed;
	}

	.space {
		padding-top: 50px;
	}

	.slideDown-enter-active, .slideDown-leave-active {
        transition: all 0.3s;
    }

    .slideDown-enter, .slideDown-leave-to {
        margin-top: -50px;
    }
</style>
