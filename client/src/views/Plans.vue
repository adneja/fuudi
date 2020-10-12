<template>
	<div class="plans">
		
	</div>
</template>


<script>
	export default {
		name: 'Plans',

		methods: {
			getPlans() {
				this.$store.dispatch('getMyPlans')
				.then((response) => {
					console.log(response);
				})
				.catch((err) => {
					console.log(err);
				});
			}
		},

		mounted() {
			this.getPlans();
		}
	}
</script>


<style lang="less" scoped>
	@import "../assets/global.less";
</style>
