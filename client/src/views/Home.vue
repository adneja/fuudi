<template>
	<div class="home d-flex justify-content-center">
		<div class="home-container px-md-5 py-md-4 p-4">

		</div>
	</div>
</template>


<script>
	export default {
		name: 'Home'
	}
</script>


<style lang="less" scoped>
	@import "../assets/global.less";

	.home {
		padding-top: 48px;
		height: 100%;
	}

	.home-container {
		width: 100%;
		height: 100%;
		max-width: @main-content-width;
	}
</style>
