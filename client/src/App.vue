<template>
	<div id="app">
		<topbar v-if="$store.getters.showNavbar"></topbar>
		<!--<div class="space"></div>-->
		<keep-alive>
			<router-view/>
		</keep-alive>
	</div>
</template>

<script>
	import Topbar from './components/Topbar.vue';
	import Footer from './components/Footer.vue';

	export default {
		name: 'app',
		components: {
			Topbar,
			Footer
		}
	}
</script>

<style lang="less" scoped>
	@import "./assets/global.less";

	#app {
		font-family: 'Ubuntu', sans-serif;
		height: 100%;
		background-color: rgb(178, 190, 176);
	}

	.space {
		padding-top: 50px;
	}
</style>
