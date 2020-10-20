<template>
	<div class="recipes">
		<div class="filtersbackground d-flex justify-content-center mb-md-4 mb-3">
			<div class="filters-container px-md-5 py-md-4 px-3 py-4">
				<RecipeSearcher @updated="result => recipes = result"></RecipeSearcher>
			</div>
		</div>

		<div class="d-flex justify-content-center">
			<div class="recipes-content px-md-5">
				<div class="container-fluid px-md-0 px-3">
					<div class="row">
						<div v-for="(recipe, index) in recipes" v-bind:key="index" class="col-lg-4 col-md-6 px-md-3 px-2 mb-md-4 mb-3">
							<Recipe
								v-bind:id="recipe.id"
								v-bind:title="recipe.name"
								v-bind:description="recipe.description"
								v-bind:cookingTime="recipe.cooking_time"
								v-bind:rating="recipe.rating"
								v-bind:numOfRatings="recipe.number_of_ratings"
								v-bind:created="recipe.created_epoch"
								v-bind:author="recipe.created_by"
								v-bind:isFavorite="recipe.bookmarked"
								v-bind:fileId="recipe.file_id"
								v-bind:fileType="recipe.file_type"
								v-bind:matchCount="recipe.match_count"
								v-bind:numOfIngredients="recipe.num_of_ingredients"></Recipe>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>


<script>
	import Recipe from '../components/Recipe.vue';
	import checkboxItems from '../utils/checkboxItems.js';
	import RecipeSearcher from  '../components/RecipeSearcher.vue';

	export default {
		name: 'Recipes',

		components: {
			Recipe,
			RecipeSearcher
		},

		data() {
			return {
				recipes: [],
			}
		}
	}
</script>


<style lang="less" scoped>
	@import "../assets/global.less";

	.recipes {
		padding-top: 48px;
		background-color: rgb(227, 234, 235);
	}

	.filtersbackground {
		background-color: white;
	}

	.recipes-content {
		width: 100%;
		max-width: @main-content-width;
	}

	.filters-container {
		width: 100%;
		max-width: @main-content-width;
	}
</style>
