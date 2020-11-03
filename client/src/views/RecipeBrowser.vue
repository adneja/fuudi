<template>
	<div class="recipes flex-center-start">
		<div class="recipes-content px-md-5 pt-md-4 p-3">
			<Filter 
				searchAction="recipesQuery" 
				@updated="result => recipes = result"/>

			<div class="container-fluid pt-md-4 pt-3">
				<div class="row row-adjustment">
					<div v-for="(recipe, index) in recipes" :key="index" class="col-lg-4 col-md-6 mb-md-4 mb-3">
						<RecipeCard
							:id="recipe.id"
							:title="recipe.name"
							:description="recipe.description"
							:cookingTime="recipe.cooking_time"
							:rating="recipe.rating"
							:numOfRatings="recipe.number_of_ratings"
							:created="recipe.created_epoch"
							:createdBy="recipe.created_by"
							:createdByName="recipe.created_by_name"
							:isFavorite="recipe.is_favorite"
							:fileId="recipe.file_id"
							:fileType="recipe.file_mimetype"
							:matchCount="recipe.matching_ingredients">
						</RecipeCard>
					</div>
				</div>
			</div>
		</div>

		<div class="add-new-container flex-end-center">
			<div class="filters-container flex-end-center px-md-5 px-3 pb-md-4 pb-3">
				<router-link to="/createrecipe" title="Create new recipe">
					<div class="add-new">
						<i class="fas fa-plus"></i>
					</div>
				</router-link>
			</div>
		</div>
	</div>
</template>

<script>
	import RecipeCard from '../components/RecipeCard.vue';
	import Filter from '../components/Filter/Filter.vue';

	export default {
		name: 'Recipes',

		components: {
			RecipeCard,
			Filter
		},

		data() {
			return {
				recipes: []
			}
		}
	}
</script>

<style lang="less" scoped>
	@import "../assets/styles/custom.less";

	.recipes {
		padding-top: 48px;
		background-color: rgba(227, 234, 235, 0.63);
		min-height: 100vh;
	}

	.recipes-content {
		width: 100%;
		max-width: @main-content-width;
	}

	.add-new-container {
		position: fixed;
		bottom: 0px;
		right: 0px;
		width: 100%;
	}

	.add-new {
		background-color: @main-background;
		width: 40px;
		height: 40px;
		box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
		display: flex;
		justify-content: center;
		align-items: center;
		color: @main-color;
		border-radius: 50%;
		
		i {
			font-size: 16pt;
		}
	}

	.add-new:hover {
		background-color: @main-background;
		color: @main-color;
		cursor: pointer;
		text-decoration: none;
	}
</style>
