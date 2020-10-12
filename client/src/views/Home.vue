<template>
	<div class="home d-flex justify-content-center">
		<div class="home-container">

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

	.home-container {
		width: 100%;
		max-width: @main-content-width;
		padding: @main-padding-horizontal;
	}

	.placeholder {
		border-radius: 0.2rem;
		background-color: rgb(221, 221, 221);
		height: 50px;
	}
</style>
