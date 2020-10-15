<template>
	<div class="recipes d-flex justify-content-center">
		<div class="recipes-content">
			
			<!-- Search & filter window -->
			<div class="mb-2 dark">Search & filter all recipes</div>

			<Window class="searchWindow">
				<div class="container-fluid">
					<div class="row">
						<div class="col-12">
							<div class="input-group mb-2">
								<input v-model="search" class="form-control form-control-sm" placeholder="">
								<div class="input-group-append">
									<button class="btn btn-sm btn-outline-light"><i class="fas fa-search"></i></button>
								</div>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="order-md-first order-last col-md-7 d-flex justify-content-md-start justify-content-between">
							<button type="button" class="btn btn-sm btn-outline-light mr-2">
								<i class="fas fa-pepper-hot mr-1"></i>
								<span v-bind:class="[ingredients.lenght > 0 ? 'font-weight-bold' : '']">Ingredient search</span>
								<span v-if="ingredients.lenght > 0 " class="font-weight-bold">: {{ingredients.length}}</span>
							</button>

							<button type="button" class="btn btn-sm btn-outline-light">
								<i class="fas fa-filter mr-1"></i>
								<span class="d-md-inline d-none">Filters</span>
							</button>
						</div>

						<div class="order-md-last order-first col-md-5 mb-md-0 mb-2 text-md-right">
							<div class="btn-group w-100" role="group" aria-label="Basic example">
								<button 
									type="button" 
									class="btn btn-sm btn-outline-light"
									v-bind:class="[sortOrder === 'popular' ? 'selected'  : '']"
									v-on:click="sortOrder = 'popular'">
									<i class="fas fa-fire-alt mr-md-1 mr-0"></i>
									<span class="d-md-inline d-none">Popular</span>
								</button>

								<button 
									type="button" 
									class="btn btn-sm btn-outline-light"
									v-bind:class="[sortOrder === 'top' ? 'selected'  : '']"
									v-on:click="sortOrder = 'top'">
									<i class="fas fa-star mr-md-1 mr-0"></i>
									<span class="d-md-inline d-none">Top</span>
								</button>

								<button 
									type="button" 
									class="btn btn-sm btn-outline-light"
									v-bind:class="[sortOrder === 'new' ? 'selected'  : '']"
									v-on:click="sortOrder = 'new'">
									<i class="far fa-clock mr-md-1 mr-0"></i>
									<span class="d-md-inline d-none">New</span>
								</button>
							</div>
						</div>
					</div>
				</div>
			</Window>
			
			<!-- Recipes -->
			<div class="container-fluid">
				<div class="row">
					<div v-for="(recipe, index) in recipes" v-bind:key="index" class="col-lg-3 col-md-4">
						<div class="recipe">
							<router-link v-bind:to="'/recipes/recipe/' + recipe.id">
								<img width="100%" v-if="recipe.file_id" v-bind:src="getImgUrl(recipe)">

								<div class="recipe-description">
									<div class="title">{{recipe.name}}</div>
									<span class="normalFont">
										<span class="by">by </span>
										<span class="author">{{recipe.created_by}}</span>
									</span>
									
									<div class="description normalFont">{{recipe.description}}</div>
								</div>

								<div class="info d-flex justify-content-between">
									<div>
										<i class="far fa-clock mr-1"></i>
										<span>{{formatCookingTime(recipe.cooking_time)}}</span>
									</div>
									
									<div class="d-flex justify-content-end align-items-center" v-if="recipe.rating">
										<Stars v-bind:stars="recipe.rating" max="5"></Stars>
										<span class="numberOfRatings">({{recipe.number_of_ratings}})</span>
									</div>
								</div>
							</router-link>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<!--
		<div class="createRecipe">
			<router-link to="/createrecipe" title="Create recipe">
				<i class="fas fa-plus-circle"></i>
			</router-link>
		</div>
		-->
	</div>
</template>


<script>
	import Window from '../components/Window.vue';
	import Stars from '../components/Stars.vue';

	export default {
		name: 'Recipes',

		components: {
			Window,
			Stars
		},

		data() {
			return {
				search: '',
				sortOrder: 'popular',
				vegan: false,
				vegetarian: false,
				glutenFree: false,
				timeLimit: null,
				ingredients: [],
				allergens: [],

				recipes: [],
			}
		},

		methods: {
			getRecipes() {
				this.$store.dispatch('getRecipes')
				.then((response) => {
					console.log(response);
					this.recipes = response;
				})
				.catch((err) => {
					console.log(err);
				});
			},

			getImgUrl(recipe) {
				return `http://10.0.0.34:3333/api/files/img/${recipe.file_id}.${recipe.file_type.split('/')[1]}`;
			},

			formatCookingTime(cookingTime) {
				let hours = Math.floor(cookingTime / 60),
					minutes = cookingTime - (hours * 60);

				if(hours) {
					return `${hours}h${minutes > 0 ? minutes + 'm' : ''}`;
				} else {
					return `${minutes}m`;
				}

			}
		},

		activated() {
			this.getRecipes();
		}
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

	.recipe {
		background-color: @main-color;
		border-radius: 0.25rem;
		box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
		//margin-left: 20px;
		//margin-right: 20px;
		margin-bottom: 40px;
		position: relative;
		transition: transform .2s;
	}

	.recipe:hover {
		transform: scale(1.02);
		cursor: pointer;
	}

	.recipe-description {
		padding: 20px;
		height: 190px;
	}

	.heart {
		position: absolute;
		top: 10px;
		right: 10px;
		background-color: white;
		border-radius: 50%;
		width: 25px;
		height: 25px;
		display: flex;
		align-content: center;
		justify-content: center;
		padding-top: 4px;
		padding-left: 1px;

		i {
			color: @main-background;
		}
	}

	img {
		border-top-left-radius: 0.25rem;
		border-top-right-radius: 0.25rem;
		height: 200px;
		object-fit: cover;
	}

	a:hover {
		text-decoration: none !important;
	}

	.title {
		color: @main-background-dark;
		font-size: 14pt;
		margin-bottom: -2px;
		line-height: 1.2rem;
		//letter-spacing: 0.06rem;

		overflow : hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}

	.info {
		background-color: @main-background;
		color: @main-color;
		padding: 5px 20px;
		padding-bottom: 0px;

		background-color: @main-color;
		color: @main-background;

		position: absolute;
		bottom: 10px;
		left: 0px;
		width: 100%;
	}

	.searchWindow {
		margin-bottom: 40px;
	}

	.description {
		font-size: 10pt;
		opacity: 0.6;
		word-wrap: normal;
		color: black;
		margin-top: 5px;
		height: 60px;

		/*
		overflow: hidden;
		text-overflow: ellipsis;
		*/

		//margin-bottom: 20px;

		overflow : hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 3;
		-webkit-box-orient: vertical;
	}
	
	.by {
		font-size: 10pt !important;
		color: @main-background-dark;
		font-weight: 600;

	}

	.author {
		font-size: 10pt !important;
		color: @main-background-dark;
		font-weight: 600;
	}

	.container-fluid {
		padding: 0px !important;
	}

	.selected {
		background-color: @main-color;
		color: @main-background;
	}

	.numberOfRatings {
		font-size: 10pt;
		margin-left: 4px;
		opacity: 0.7;
	}

	.createRecipe {
		position: fixed;
		bottom: 10px;
		right: 13px;

		a {
			color: @main-background-dark !important;
		}

		i {
			font-size: 30pt;
			background-color: white;
			border-radius: 50%;
			border: 2px solid white;
		}
	}
</style>
