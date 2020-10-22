<template>
	<div class="recipes">
		<div class="filtersbackground d-flex justify-content-center mb-md-4 mb-3">
			<div class="filters-container px-md-5 py-md-4 px-3 py-4">
				<RecipeSearcher 
					@ingredient-search-updated="isEmpty => showMatchCount = isEmpty" 
					@updated="result => recipes = result">
				</RecipeSearcher>
			</div>
		</div>

		<div class="d-flex justify-content-center">
			<div class="recipes-content px-md-5">
				<div class="container-fluid px-md-0 px-4">
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
								v-bind:numOfIngredients="recipe.num_of_ingredients"
								v-bind:showMatchCount="showMatchCount"></Recipe>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="add-new-container d-flex justify-content-center">
			<div class="filters-container d-flex justify-content-end px-md-5 px-3 pb-md-4 pb-3">
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
				showMatchCount: false
			}
		}
	}
</script>


<style lang="less" scoped>
	@import "../assets/global.less";

	.recipes {
		padding-top: 48px;
		background-color: rgba(227, 234, 235, 0.63);
		min-height: 100vh;
	}

	.filtersbackground {
		background-color: white;
		box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
	}

	.recipes-content {
		width: 100%;
		max-width: @main-content-width;
	}

	.filters-container {
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
