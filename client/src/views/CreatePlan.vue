<template>
	<div class="createplan">
		<div class="d-flex justify-content-center">
			<div class="createplan-container px-md-5 pt-md-4 px-3 pt-3">
				<div class="mb-3">
					Add a recipe by clicking it:
				</div>

				<div class="container-fluid">
					<div class="row">
						<div class="col-12 px-0 pb-md-4 pb-3">
							<RecipeSearcher 
								@ingredient-search-updated="isEmpty => showMatchCount = isEmpty" 
								@updated="result => recipes = result">
							</RecipeSearcher>
						</div>
					</div>

					<div class="row row-adjustment">
						<div v-for="(recipe, index) in recipes" :key="index" class="col-md-4 mb-4">
							<div class="recipe-wrapper" @click="addToPlan(recipe)">
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
									v-bind:showMatchCount="showMatchCount"
									v-bind:dontLink="true">
								</Recipe>

								<div v-if="existsInPlan(recipe)" class="selection-count">
									<i class="fas fa-times"></i>
									<span>{{getSelectionCount(recipe)}}</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="selected-recipes">
			<div class="d-flex justify-content-center pointer" @click="showSelected = !showSelected">
				<div class="createplan-container px-md-5 py-md-3 px-3 py-3">
					<div class="d-flex justify-content-between align-items-center">
						<div class="d-flex justify-content-start align-items-center">
							<i v-if="!showSelected" class="fas fa-angle-double-up mr-2"></i>
							<i v-else class="fas fa-angle-double-down mr-2"></i>
							<div>{{selectedRecipes.length}} recipe{{selectedRecipes.length > 1 ? 's' : ''}} selected</div>
						</div>
						<button class="btn btn-sm btn-outline-light"><i class="fas fa-plus mr-2"></i>Create plan</button>
					</div>
				</div>
			</div>

			<transition name="slideUp">
				<div class="d-flex justify-content-center show-selected-recipes" v-if="showSelected">
					<div class="createplan-container px-md-5 pt-md-4 px-3 pt-3">
						<div class="contaier-fluid">
							<div class="row">
								<div class="col-md-2 col-4 mb-md-4 mb-3" v-for="(recipe, index) in selectedRecipes" :key="index">
									<div class="day">Day {{index+1}}</div>
									<div class="selected-recipe">
										<div class="img-wrapper">
											<img :src="imgURL(recipe)">

											<div class="remove pointer" @click="removeFromPlan(index)">
												<i class="fas fa-times-circle"></i>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>	
					</div>
				</div>
			</transition>
		</div>
	</div>
</template>


<script>
	import Recipe from '../components/Recipe.vue';
	import RecipeSearcher from '../components/RecipeSearcher.vue';

	export default {
		name: 'CreatePlan',
		components: {Recipe, RecipeSearcher},

		data() {
			return {
				showMatchCount: false,
				recipes: [],
				selectedRecipes: [],
				showSelected: false
			}
		},

		computed: {
			recipesFiltered() {
				return this.recipes.filter((recipe) => !this.existsInPlan(recipe));
			}
		},

		methods: {
            imgURL(recipe) {
                return `${process.env.VUE_APP_REST_ADDR}/api/files/img/${recipe.file_id}.${recipe.file_type.split('/')[1]}`;
			},

			getSelectionCount(recipe) {
				return this.selectedRecipes.filter((selected) => selected.id === recipe.id).length;
			},

			existsInPlan(recipe) {
				return this.selectedRecipes.some((selected) => selected.id === recipe.id);
			},
			
			addToPlan(recipe) {
				this.selectedRecipes.push(recipe);
			},

			removeFromPlan(index) {
				this.selectedRecipes.splice(index, 1);

				if(this.selectedRecipes.length === 0) {
					this.showSelected = false;
				}
			}
		}
	}
</script>


<style lang="less" scoped>
	@import "../assets/global.less";

	.createplan {
		padding-top: 48px;
		background-color: rgba(227, 234, 235, 0.63);
		min-height: 100vh;
		color: @main-background;
	}

	.createplan-container {
		width: 100%;
		max-width: @main-content-width;
	}

	.details {
		background-color: white;
		box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
	}

	input, input:focus, textarea, textarea:focus {
		border: 1px solid @main-background !important;
	}

	.row-adjustment {
		margin-left: -30px;
		margin-right: -30px;
	}


	.title {
		font-size: 20pt;
		margin-bottom: 10px;
	}

	.recipe-wrapper, .img-wrapper {
		position: relative;
	}

	.selection-count {
		position: absolute;
		top: 10px;
		right: 10px;
		background-color: @main-background;
		color: @main-color;
		width: 35px;
		height: 35px;
		border-radius: 50%;
		display: flex;
		justify-content:center;
		align-items:center;

		i {
			font-size: 7pt;
			margin-right: 2px;
			margin-top: -1px;
		}
	}

	.selected {
		position: absolute;
		top: 0px;
		left: 0px;
		width: 100%;
		height: 100%;
		backdrop-filter: grayscale(0.5);

		i {
			background-color: white;
			border-radius: 50%;
			border: 1px solid @main-color;
		}
	}

    img {
        height: 100px;
        width: 100%;
		object-fit: cover;
	}

	.remove {
		position: absolute;
		top: -8px;
		right: -8px;

		i {
			color: @main-background;
			background-color: white;
			border-radius: 50%;
			font-size: 16pt;
		}
	}

	.selected-recipes {
		position: fixed;
		bottom: 0px;
		left: 0px;
		width: 100vw;
		z-index: 99999999;
		background-color: @main-background;
		color: @main-color;
	}

	.show-selected-recipes {
		background-color: rgba(227, 234, 235, 0.63);
		background-color: white;
		height: calc(60vh - 63px);
		overflow-y: auto;
	}

	.selected-recipe {
		box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
	}

	.day {
		color: @main-background;
	}

	.btn-outline-light {
		background-color: @main-color;
		color: @main-background;
	}

	.slideUp-enter-active, .slideUp-leave-active {
		transition: all 0.4s;
	}

	.slideUp-enter-from, .slideUp-leave-to {
		margin-bottom: calc(-60vh + 63px);
	}
</style>
