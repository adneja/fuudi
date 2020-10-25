<template>
	<div class="createplan">
		<div class="d-flex justify-content-center">
			<div class="createplan-container px-md-5 pt-md-4 px-3 pt-3">
				<div class="title"><i class="far fa-calendar-check mr-2"></i>New plan</div>
				<div class="muted mb-2">
					<small>Start by adding recipes to your meal plan</small>
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
						<div 
							v-for="(recipe, index) in recipes" 
							:key="index" 
							class="col-md-3 col-6 mb-4 px-2">
							<div class="recipe-wrapper">
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
									v-bind:dontLink="true"
									v-bind:small="true">
								</Recipe>

								<div v-if="existsInPlan(recipe)" class="selected d-flex justify-content-center align-items-center">
									<i class="fas fa-check-circle fa-4x"></i>
								</div>

								<div class="add-info text-center">
									<button @click="addToPlan(recipe)" class="btn btn-success w-100" v-if="!existsInPlan(recipe)">
										<i class="fas fa-plus mr-2"></i>
										<span>Add</span>
									</button>

									<div v-else class="d-flex justify-content-center align-items-center">
										<button @click="removeOne(recipe)" class="btn btn-success"><i class="fas fa-minus"></i></button>
										<div class="amount text-center">{{getSelectionCount(recipe)}}</div>
										<button @click="addToPlan(recipe)" class="btn btn-success"><i class="fas fa-plus"></i></button>
									</div>
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
							<div v-if="!showSelected" class="d-flex justify-content-start">
								<transition name="bounceIn" mode="out-in">
									<div :key="selectedRecipes.length" class="mr-1 muted selected-count">{{selectedRecipes.length}}</div>
								</transition>

								<span class="selected-count">recipe{{selectedRecipes.length > 1 || selectedRecipes.length === 0 ? 's' : ''}} selected</span>
							</div>

							<div v-else>
								<i class="fas fa-info-circle mr-2"></i>
								 <span class="muted">Plan details</span>
							</div>
						</div>

						<button v-if="!showSelected" class="btn btn-sm btn-outline-light">
							<span>Next</span>
							<i class="fas fa-chevron-right ml-2"></i>
						</button>

						<div v-else>
							<button class="btn btn-sm btn-outline-light">
								<i class="fas fa-chevron-left mr-2"></i>
								<span>Back</span>
							</button>

							<button v-if="selectedRecipes.length > 0" @click="createPlan" class="btn btn-sm btn-outline-light ml-3">								
								<i v-if="!creating" class="fas fa-plus mr-2"></i>
								<i v-else class="fas fa-circle-notch fa-spin mr-2"></i>
								<span>Create</span>
							</button>
						</div>
					</div>
				</div>
			</div>

			<transition name="slideUp">
				<div class="d-flex justify-content-center show-selected-recipes" v-if="showSelected">
					<div class="createplan-container px-md-5 pt-md-4 px-3 pt-3">
						<input v-if="selectedRecipes.length > 0" v-model="title" class="form-control mb-2" placeholder="Plan title">
	
						<div class="empty-message" v-if="selectedRecipes.length === 0">
							<small>Please add at least one recipe before proceeding</small>
						</div>

						<div v-else>
							<!--
							<div class="empty-message muted mb-2">
								<small>(Drag and drop to rearrange)</small>
							</div>
							-->

							<div class="contaier-fluid">
								<draggable :list="selectedRecipes" class="row" ghost-class="ghost">
									<transition-group>
										<div class="col-md-2 col-4 pb-md-4 pb-3" v-for="(recipe, index) in selectedRecipes" :key="index">
											<div class="selected-recipe">
												<div class="day">Day {{index+1}}</div>
												
												<div class="img-wrapper">
													<img :src="imgURL(recipe)">
													<div class="remove pointer" @click="removeFromPlan(index)">
														<i class="fas fa-times-circle"></i>
													</div>
												</div>
											</div>
										</div>
									</transition-group>
								</draggable>
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
	import { VueDraggableNext } from 'vue-draggable-next'

	export default {
		name: 'CreatePlan',
		components: {Recipe, RecipeSearcher, draggable: VueDraggableNext},

		data() {
			return {
				showMatchCount: false,
				recipes: [],
				selectedRecipes: [],
				showSelected: false,
				title: '',
				creating: false
			}
		},

		computed: {
			recipesFiltered() {
				return this.recipes.filter((recipe) => !this.existsInPlan(recipe));
			}
		},

		methods: {
			createPlan() {
				this.creating = true;
				this.$store.dispatch('createMealplan', {
					name: this.title,
					recipes: JSON.stringify(this.selectedRecipes)
				})
				.then((response) => {
					this.$store.commit('setSystemMessage', {
						content: 'New plan created!',
						error: false
					});

					this.$router.push({route: `/plans/plan/${response.id}`});
				})
				.catch((err) => {
					this.$store.commit('setSystemMessage', {
						content: err,
						error: true
					});
				})
				.finally(() => {
					this.creating = false;
				});
			},

			clear() {
				this.selectedRecipes =  [];
				this.showSelected = false;
			},

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

			removeOne(recipe) {
				let deleteIndex = null;

				for(var i = 0; i < this.selectedRecipes.length; i++) {
					if(this.selectedRecipes[i].id === recipe.id) {
						deleteIndex = i;
						break;
					}
				}

				this.selectedRecipes.splice(deleteIndex, 1);
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
		padding-bottom: 63px;
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
		margin-left: -22px;
		margin-right: -22px;
	}


	.title {
		font-size: 20pt;
		margin-bottom: 0px;
	}

	.recipe-wrapper, .img-wrapper {
		position: relative;
	}

	.img-wrapper {
		box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
	}

	.img-wrapper:hover {
		cursor:grab;
	}

	.selection-count {
		position: absolute;
		bottom: 10px;
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
			//margin-top: -1px;
		}
	}
	
	.add-info {
		position: absolute;
		bottom: 10px;
		right: 0px;
		width: 100%;
		padding-left: 10px;
		padding-right: 10px;
	}

	.selected {
		position: absolute;
		top: 0px;
		left: 0px;
		width: 100%;
		height: 140px;
		padding: 20px;
		backdrop-filter: brightness(50%);

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
		user-select: none;
		touch-action: none;
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
		z-index: 99999;
		max-height: 100%;
		background-color: @main-background;
		color: @main-color;
		box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
	}

	.show-selected-recipes {
		position: relative;
		background-color: rgba(227, 234, 235, 0.63);
		background-color: white;
		height: calc(100vh - 63px);
		overflow-y: auto;
	}

	.create-plan {
		position: absolute;
		bottom: 0px;
		right: 0px;
		width: 100%;
	}

	.selected-recipe {
		//box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
		color: @main-background;
	}

	.btn-outline-light {
		background-color: @main-color;
		color: @main-background;
	}

	.empty-message {
		color: @main-background;
	}

	.amount {
		width: 30px;
	}

	.selected-count {
		font-size: 15pt;
	}

	// transitions

	.slideUp-enter-active, .slideUp-leave-active {
		transition: all 0.4s;
	}

	.slideUp-enter-from, .slideUp-leave-to {
		margin-bottom: calc(-100vh + 63px);
	}

	.bounceIn-enter-active, .bounceIn-leave-active {
		transition: all 0.1s;
	}

	.bounceIn-enter-from, .bounceIn-leave-to {
		//opacity: 0;
		transform: scale(1.2);
	}

	.fadeIn-enter-active, .fadeIn-leave-active {
		transition: opacity 0.1s;
	}

	.fadeIn-enter-from, .fadeIn-leave-to {
		opacity: 0;
	}

	.nohover:hover {
		cursor: default !important;
	}
</style>
