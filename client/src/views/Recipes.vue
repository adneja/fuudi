<template>
	<div class="recipes d-flex justify-content-center">
		<div class="recipes-content">
			<div class="text-right">
				<router-link to="/createrecipe">
					<span class="btn btn-success">
						Create recipe
					</span>
				</router-link>
			</div>
		</div>
	</div>
</template>


<script>
	export default {
		name: 'Recipes'
	}
</script>


<style lang="less" scoped>
	@import "../assets/global.less";

	.recipes {
		padding-top: 50px;
	}

	.recipes-content {
		width: 100%;
		max-width: @main-content-width;
		padding: @main-padding-horizontal;
	}
</style>
