
<template>
	<div class="recipes">
		<div class="d-flex justify-content-center ">
			<!-- Search & filter window -->
			<div class="filters-container px-md-5 py-md-4 px-4 py-4">
				<div class="input-group filterRow mb-3">
					<input v-model="search" class="form-control" placeholder="Search">

					<div class="input-group-append">
						<button 
							type="button" 
							class="btn w-100 filterButton" 
							v-bind:class="[showFilters ? 'btn-success ' : 'btn-outline-light']"
							v-on:click="showFilters = !showFilters">

							<i class="fas fa-filter mr-1"></i>
							<span class="">
								<span>Filters</span>
								<span class="muted ml-1" v-if="numAppliedFilters > 0">({{numAppliedFilters}})</span>
							</span>
						</button>
					</div>
				</div>
				
				<div class="filters lightblue" v-if="showFilters">
					<!-- Diatary constraints -->
					<div class="mb-2 filterTitle">Dietary constraints</div>
					<div class="d-flex flex-wrap mb-3">
						<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="filters.vegan = !filters.vegan">
							<div class="cb">
								<i v-if="filters.vegan" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Vegan</span>
						</div>

						<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="filters.vegetarian = !filters.vegetarian">
							<div class="cb">
								<i v-if="filters.vegetarian" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Vegetarian</span>
						</div>

						<div class="cb-container pointer mr-3" v-on:click="filters.glutenFree = !filters.glutenFree">
							<div class="cb">
								<i v-if="filters.glutenFree" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Gluten Free</span>
						</div>
					</div>
					
					<!-- Allergens -->
					<div class="mb-2 filterTitle">Exclude allergens</div>
					<div class="d-flex flex-wrap mb-3">
						<div class="allergen cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="filters.milk = !filters.milk">
							<div class="cb">
								<i v-if="filters.milk" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Milk</span>
						</div>

						<div class="allergen cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="filters.egg = !filters.egg">
							<div class="cb">
								<i v-if="filters.egg" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Egg</span>
						</div>

						<div class="allergen cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="filters.nuts = !filters.nuts">
							<div class="cb">
								<i v-if="filters.nuts" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Nuts</span>
						</div>

						<div class="allergen cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="filters.wheat = !filters.wheat">
							<div class="cb">
								<i v-if="filters.wheat" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Wheat</span>
						</div>

						<div class="allergen cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="filters.soy = !filters.soy">
							<div class="cb">
								<i v-if="filters.soy" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Soy</span>
						</div>

						<div class="allergen cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="filters.fish = !filters.fish">
							<div class="cb">
								<i v-if="filters.fish" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Fish</span>
						</div>

						<div class="allergen cb-container pointer" v-on:click="filters.shellfish = !filters.shellfish">
							<div class="cb">
								<i v-if="filters.shellfish" class="fas fa-check"></i>
							</div>
							<span class="cb-label">Shellfish</span>
						</div>
					</div>

					<!-- Max cooking time -->
					<div class="filterTitle">
						<span>Max cooking time:</span>
						<span class="ml-1 normalFont font-weight-bold cookingTime">
							<span v-if="maxCookingTime >= 120">2h+</span>
							<span v-else>{{formatCookingTime(maxCookingTime)}}</span>
						</span>
					</div>

					<div class="slidecontainer">
						<input v-on:change="getRecipes" v-model="maxCookingTime" type="range" min="1" max="120" value="120" class="slider w-100" id="myRange">
					</div>
				</div>

				<div class="d-flex justify-content-between">
					<span class="clickable">
						<!--<i class="fas fa-pepper-hot mr-1"></i>-->
						<i class="fas fa-search mr-1"></i>
						<span v-bind:class="[ingredients.lenght > 0 ? 'font-weight-bold' : '']">Search by Ingredients</span>
						<span v-if="ingredients.lenght > 0 " class="font-weight-bold">: {{ingredients.length}}</span>
					</span>
				
					<!-- Sort order-->
					<div 
						class="sortOrder d-flex justify-content-end align-items-center"
						id="dropdownMenu1" 
						aria-haspopup="true" aria-expanded="false" data-toggle="dropdown">

						<span>{{sortOrder}}</span>
						<i class="fas fa-sort ml-2"></i>
					</div>

					<div class="dropdown-menu" aria-labelledby="dropdownMenu1">
						<a 
							class="dropdown-item" 
							href="#!" 
							v-on:click="sortOrder = 'popular'">
							Popular
						</a>

						<a 
							class="dropdown-item" 
							href="#!" 
							v-on:click="sortOrder = 'rating'">
							Rating
						</a>

						<a 
							class="dropdown-item" 
							href="#!" 
							v-on:click="sortOrder = 'new'">
							New
						</a>
					</div>
				</div>
			</div>
		</div>

		<!-- Recipes -->
		<div class="d-flex justify-content-center">
			<div class="recipes-content px-md-5 p-2">
				<div class="container-fluid px-md-0 px-4">
					<div class="row">
						<div v-for="(recipe, index) in recipes" v-bind:key="index" class="col-lg-4 col-md-6 px-md-3 px-2">
							<div class="recipe mb-md-4 mb-4">
									<div class="authorRow d-flex justify-content-between align-items-center">
										<div class="d-flex justify-content-start align-items-center">
											<i class="far fa-user-circle mr-2"></i>
											<span>{{recipe.created_by}}</span>
										</div>

										<span v-on:click="bookmark(recipe)" class="pointer" title="Add to cookbook">
											<i v-if="!recipe.bookmarked" class="far fa-star bookmark"></i>
											<i v-else class="fas fa-star bookmark"></i>
										</span>
									</div>

									<router-link class="clickable" v-bind:to="'/recipes/recipe/' + recipe.id">
										<img v-bind:alt="`Image of meal: ${recipe.name}`" width="100%" v-if="recipe.file_id" v-bind:src="getImgUrl(recipe)">

										<div class="recipe-description">
											<div class="title d-flex justify-content-between align-items-start">
												<span class="recipeTitle">{{recipe.name}}</span>

												<div 
													class="stars d-flex justify-content-end align-items-center"
													v-if="recipe.number_of_ratings > 0">
													
													<Stars v-bind:stars="recipe.rating" max="5"></Stars>
													<span class="numberOfRatings">({{recipe.number_of_ratings}})</span>
												</div>
											</div>
											<div class="description normalFont">{{recipe.description}}</div>
											
											<div class="d-flex justify-content-between align-items-center">
												<div>
													<i class="far fa-clock mr-1 d-none"></i>
													<span class="normalFont cookingTime font-weight-bold">{{formatCookingTime(recipe.cooking_time)}}</span>
												</div>

												<div class="font-weight-bold cookingTime normalFont">{{timeFromEpoch(recipe.created_epoch)}}</div>
											</div>
										</div>
								</router-link>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
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
				search: window.localStorage.getItem('recipe-search') || '',
				sortOrder: window.localStorage.getItem('recipe-sort-order') || 'popular',
				vegan: false,
				vegetarian: false,
				glutenFree: false,
				timeLimit: null,
				ingredients: [],
				allergens: [],

				recipes: [],

				searchTimeout: null,
				searching: false,
				showFilters: false,
				
				filters: JSON.parse(window.localStorage.getItem('recipe-filters')) || {
					vegan: false,
					vegetarian: false,
					glutenFree: false,
					milk: false,
					egg: false,
					nuts: false,
					wheat: false,
					soy: false,
					fish: false,
					shellfish: false
				},
				maxCookingTime: 120
			}
		},

		computed: {
			filtersString() {
				return JSON.stringify(this.filters)
			},

			numAppliedFilters() {
				let num = this.maxCookingTime < 120 ? 1 : 0;

				Object.keys(this.filters).forEach((key) => {
					if(this.filters[key]) {
						num++;
					}
				});

				return num;
			},

			isLoggedIn() {
				return this.$store.getters.token !== null;
			}
		},

		methods: {
			getRecipes() {
				this.$store.dispatch('getRecipes', {
					search: this.search,
					sort_order: this.sortOrder,
					filters: this.filtersString
				})
				.then((response) => {
					this.recipes = response;
				})
				.catch((err) => {
					this.$store.commit('setSystemMessage', {
						content: err,
						error: true
					});
				})
				.finally(() => {
					this.searching = false;
				});
			},

			getImgUrl(recipe) {
				return `http://10.0.0.34:3333/api/files/img/${recipe.file_id}.${recipe.file_type.split('/')[1]}`;
			},

			formatCookingTime(cookingTime) {
				let hours = Math.floor(cookingTime / 60),
					minutes = cookingTime - (hours * 60);

				if(hours) {
					return `${hours}h ${minutes > 0 ? minutes + 'm' : ''}`;
				} else {
					return `${minutes}m`;
				}

			},

			updateRecipes() {
				this.searching = true;
				clearTimeout(this.searchTimeout);

				this.searchTimeout = setTimeout(() => {
					this.getRecipes();
				}, 600);
			},

			timeFromEpoch(timestamp) {
				let date = new Date(timestamp * 1000);

				return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()}`;
			},

			bookmark(recipe) {
				this.$store.dispatch('bookmark', {
					id: recipe.id
				})
				.then((response) => {
					recipe.bookmarked = response;
					this.$store.commit('setSystemMessage', {
						content: `Recipe ${response ? 'added to' : 'removed from'} favorites.`,
						error: false
					});
				})
				.catch((err) => {
					this.$store.commit('setSystemMessage', {
						content: err,
						error: true
					});
				});
			}
		},

		watch: {
			search() {
				this.updateRecipes();
				window.localStorage.setItem('recipe-search', this.search);
			},

			sortOrder() {
				this.updateRecipes();
				window.localStorage.setItem('recipe-sort-order', this.sortOrder);
			},

			filtersString() {
				this.updateRecipes();
				window.localStorage.setItem('recipe-filters', this.filtersString);
			},

			isLoggedIn() {
				this.updateRecipes();
			}
		},

		activated() {
			this.searching = true;
			this.getRecipes();
		}
	}
</script>


<style lang="less" scoped>
	@import "../assets/global.less";

	.recipes {
		padding-top: 48px;
	}

	.recipes-content {
		width: 100%;
		max-width: @main-content-width;
		margin-top: -14px;
	}

	.filters-container {
		width: 100%;
		max-width: @main-content-width;
	}

	.filters {
		color: @main-background;
		border: 1px solid @main-background;
		border-top: none;
		padding: 12px 12px;
		margin-bottom: 10px;
		margin-top: -16px;
	}

	.filterTitle {
		font-size: 12pt;
	}

	.recipe {
		background-color: @main-color;
		position: relative;
		transition: transform .2s;
		box-shadow: 2px 2px 7px rgba(0, 0, 0, 0.2);
	}

	.recipe:hover {
		transform: scale(1.02);
	}

	.recipe-description {
		padding: 20px;
		padding-top: 15px;
		height: 200px;
	}

	.authorRow {
		background-color: @main-background;
		color: @main-color;
		padding: 8px 20px;

		font-size: 12pt;

		i {
			font-size: 14pt;
		}

		.bookmark {
			font-size: 14pt;
		}
	}

	img {
		height: 200px;
		object-fit: cover;
	}

	a:hover {
		text-decoration: none !important;
	}

	.title {
		color: @main-background;
		font-size: 14pt;
		margin-bottom: -2px;
		line-height: 1.2rem;
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
		bottom: 12px;
		left: 0px;
		width: 100%;
	}

	.description {
		font-size: 11pt;
		opacity: 1;
		word-wrap: normal;
		color: @main-background-dark;
		margin-top: 15px;
		margin-bottom: 10px;
		height: 90px;
		overflow : hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 4;
		-webkit-box-orient: vertical;
	}

	.created {
		font-size: 9pt;
		opacity: 0.9;
		color: @main-background-dark;
	}

	.author {
		font-size: 10pt !important;
		color: @main-background-dark;
		font-weight: 600;
	}

	.selected {
		background-color: @main-background;
		color: @main-color !important;
	}

	.numberOfRatings {
		font-size: 12pt;
		margin-left: 4px;
		opacity: 0.6;
		margin-bottom: -3px;
	}

	.stars {
		margin-top: -1px;
	}

	.filterRow {
		.btn {
			color: @main-background;
			border: 1px solid @main-background;
		}

		.btn:hover {
			background-color: @main-background;
			color: @main-color;
			border: 1px solid @main-background;
		}

		.btn:active {
			background-color: @main-background-dark;
			color: @main-color !important;
			border: 1px solid @main-background;
		}

		input {
			border: 1px solid @main-background;
		}

		input:focus {
			border: 1px solid @main-background !important;
		}
	}	

	.dropdown-item  {
		color: @main-background;
		padding: 0px 10px;
	}

	.dropdown-item:hover {
		background-color: @main-color !important;
		color:@main-background-dark  !important;
	}

	.dropdown-menu, .btn-dropdown, .filterButton  {
		min-width: 82px !important;
	}

	.sortOrder {
		color: @main-background;
		min-width: 82px !important;
		font-size: 12pt;
	}

	.sortOrder:hover {
		cursor: pointer;
	}

	.ingredientSearch {
		color: @main-background;
	}

	.ingredientSearch:hover {
		text-decoration: underline;
	}

	.cookingTime {
		font-size: 10pt;
	}

	.clickable {
		color: @main-background;
		font-size: 12pt;
	}

	.clickable:hover {
		cursor: pointer;
		text-decoration: underline;
	}

	.recipeTitle {
		width: calc(100% - 115px);

		height: 38px;
		overflow : hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
	}

	.btn-outline-light:focus, .btn-outline-light:active, .btn-outline-light:hover {
		background-color:@main-color !important;
		color: @main-background !important;
	}

	.btn-outline-light:active {
		background-color:@main-color !important;
		color: @main-background !important;
	}
</style>
