<template>
	<div id="app">
		<Topbar v-if="$store.getters.showNavbar"></Topbar>

		<transition name="slideDown">
            <SystemMessage v-show="$store.getters.systemMessage"></SystemMessage>
        </transition>

		<!--<div class="space"></div>-->
		<keep-alive>
			<router-view/>
		</keep-alive>
	</div>
</template>

<script>
	import Topbar from './components/Topbar.vue';
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
		background-color: rgb(198, 194, 204);
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
