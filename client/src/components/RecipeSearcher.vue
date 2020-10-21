<template>
    <div class="recipesearcher">
        <div class="input-group search-row mb-3">
            <input v-model="search" class="form-control" placeholder="Search">
            <!--<i class="search-indicator fas fa-circle-notch fa-spin"></i>-->

            <div class="input-group-append">
                <button 
                    type="button" 
                    class="btn w-100 filterButton" 
                    v-bind:class="[showFilters ? 'btn-success ' : 'btn-outline-light']"
                    @click="showFilters = !showFilters">

                    <i class="fas fa-filter mr-1"></i>
                    <span class="">
                        <span>Filters</span>
                        <span class="muted ml-1" v-if="numAppliedFilters > 0">({{numAppliedFilters}})</span>
                    </span>
                </button>
            </div>
        </div>

        <div class="filters" v-if="showFilters">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-6 px-0">
                        <div class="mb-1 filter-title">Allergens</div>
                        
                        <CheckboxCollection
                            class="mb-3" 
                            v-bind:checkboxItems="allergens"
                            @change="items => allergens = items">
                        </CheckboxCollection>
                    </div>  

                    <div class="col-6 px-0">
                        <div class="mb-1 filter-title">Constraints</div>

                        <CheckboxCollection
                            class="mb-3" 
                            v-bind:checkboxItems="diataryConstraints"
                            @change="items => diataryConstraints = items">
                        </CheckboxCollection>
                    </div>

                    <div class="col-12 px-0">
                        <div class="filter-title">
                            <span>Max cooking time:</span>
                            <span class="ml-1 normalFont font-weight-bold">
                                <span v-if="maxCookingTime >= 120">2h+</span>
                                <span v-else>{{formattedCookingTime}}</span>
                            </span>
                        </div>

                        <div class="slidecontainer">
                            <input @change="getRecipes" v-model="maxCookingTime" type="range" min="1" max="120" class="slider w-100" id="myRange">
                        </div>

                        <div class="text-left mt-2">
                            <button v-if="numAppliedFilters > 0" class="btn btn-outline-light mt-2 mr-2" @click="clearFilters">
                                <i class="fas fa-trash mr-2"></i>
                                <span>Reset</span>
                            </button>

                            <button class="mt-2 btn btn-outline-light" @click="showFilters = false">
                                <i class="fas fa-times mr-2"></i>
                                <span>Close</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between">
            <!-- Ingredients search -->
            <span class="pointer ingredient-search" @click="showIngredientsSearch = !showIngredientsSearch">
                <span>
                    <i class="fas fa-search mr-1"></i>
                    <span>Search by Ingredients</span>
                    <span v-if="ingredients.length > 0" class="muted"> ({{ingredients.length}})</span>
                </span>
            </span>
        
            <!-- Sort order-->
            <div 
                class="sort-order d-flex justify-content-end align-items-center"
                id="dropdownMenu1" 
                aria-haspopup="true" aria-expanded="false" data-toggle="dropdown">

                <span>{{sortOrder}}</span>
                <i class="fas fa-sort ml-2"></i>
            </div>

            <div class="dropdown-menu" aria-labelledby="dropdownMenu1">
                <a 
                    class="dropdown-item" 
                    href="#!" 
                    @click="sortOrder = 'popular'">
                    Popular
                </a>

                <a 
                    class="dropdown-item" 
                    href="#!" 
                    @click="sortOrder = 'rating'">
                    Rating
                </a>

                <a 
                    class="dropdown-item" 
                    href="#!" 
                    @click="sortOrder = 'new'">
                    New
                </a>
            </div>
        </div>

        <div class="ingredients-search mt-2" v-if="showIngredientsSearch">
            <!--
            <div class="mb-2">
                <small class="normalFont letter-spacing">Add ingredients to filter recipes by:</small>
            </div>
            -->

            <SearchField 
                ref="searchfooditems"
                action="searchFoodItems" 
                displayField="name"
                placeholder="Ingredient.."
                prompt="Select ingredient"
                v-bind:enableCreatePrompt="false"
                @item-selected="addSearchIngredient">
            </SearchField>	

            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-3 col-md-4 col-12 px-0" v-for="i in Math.ceil(ingredients.length / 5)" v-bind:key="i">
                        <div class="mt-2" v-for="(ingredient, index) in ingredients.slice((i - 1) * 5, (i * 5))" v-bind:key="index">
                            <i title="Remove" class="far fa-times-circle mr-1 pointer" @click="removeIngredient(index)"></i>
                            {{ingredient.name}}
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="text-left">
                <button class="mt-2 btn btn-outline-light mr-2" v-if="ingredients.length > 0" @click="clearIngredients">
                    <i class="fas fa-trash mr-2"></i>
                <span>Reset</span>
                </button>

                <button class="mt-2 btn btn-outline-light" @click="showIngredientsSearch = false">
                    <i class="fas fa-times mr-2"></i>
                    <span>Close</span>
                </button>
            </div>
        </div>
    </div>
</template>


<script>
    import CheckboxCollection from '../components/CheckboxCollection.vue';
    import SearchField from '../components/SearchField.vue';
    import checkboxItems from '../utils/checkboxItems.js';
    import {nextTick} from 'vue';
    
    export default {
        name: 'RecipeSearcher',
        props: [],
        components: {CheckboxCollection, SearchField},

        data() {
            return {
                search: window.localStorage.getItem('recipes-search') || '',
                sortOrder: window.localStorage.getItem('recipes-sort-order') || 'popular',
                maxCookingTime: window.localStorage.getItem('recipes-max-cooking-time') || 120,
				diataryConstraints: JSON.parse(window.localStorage.getItem('recipes-diatary-constraints')) || checkboxItems.diataryConstraints,
                allergens: JSON.parse(window.localStorage.getItem('recipes-allergens')) || checkboxItems.allergens,
                ingredients: JSON.parse(window.localStorage.getItem('recipes-ingredients')) || [],
                
                searchTimeout: null,
				searching: false,
                showFilters: false,
                showIngredientsSearch: false,
                numOfResults: null
            }
        },

		computed: {
			numAppliedFilters() {
				let num = this.maxCookingTime < 120 ? 1 : 0;
                
                this.diataryConstraints.forEach((constraint) => {
                    if(constraint.checked) {
                        num++;
                    }
                });

                this.allergens.forEach((constraint) => {
                    if(constraint.checked) {
                        num++;
                    }
                });

				return num;
			},

			diataryConstraintsStringified() {
				return JSON.stringify(this.diataryConstraints);
			},

			allergensStringified() {
				return JSON.stringify(this.allergens);
            },

            ingredientsStringified() {
                return JSON.stringify(this.ingredients);
            },
            
            isLoggedIn() {
				return this.$store.getters.token !== null;
            },
            
            formattedCookingTime() {
				let hours = Math.floor(this.maxCookingTime / 60),
					minutes = this.maxCookingTime - (hours * 60);

				if(hours) {
					return `${hours}h ${minutes > 0 ? minutes + 'm' : ''}`;
				} else {
					return `${minutes}m`;
				}
            },
        },
        
        methods: {
            async addSearchIngredient(ingredient) {
                if(ingredient) {
                    this.ingredients.push(ingredient);

                    await nextTick();
                    this.$refs.searchfooditems.clear();
                    this.$refs.searchfooditems.focus();
                }
            },

            removeIngredient(ingredient) {
                this.ingredients.splice(this.ingredients.indexOf(ingredient), 1);
            },

			getRecipes() {
				this.$store.dispatch('getRecipes', {
					search: this.search,
					sort_order: this.sortOrder,
					diatary_constraints: JSON.stringify(this.checkboxArrayToObject(this.diataryConstraints)),
					allergens: JSON.stringify(this.checkboxArrayToObject(this.allergens)),
                    max_cooking_time: this.maxCookingTime,
                    ingredients: JSON.stringify(this.ingredients.map(i => i.id)) || []
				})
				.then((response) => {
                    this.$emit('updated', response);

                    if(this.search.length > 0 || this.numAppliedFilters > 0 || this.ingredients.length > 0) {
                        this.numOfResults = response.length;
                    } else {
                        this.numOfResults = null;   
                    }
                    
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
            
            updateRecipes() {
				this.searching = true;
				clearTimeout(this.searchTimeout);

				this.searchTimeout = setTimeout(() => {
					this.getRecipes();
				}, 600);
            },
            
            checkboxArrayToObject(array) {
				let obj = {};
				array.forEach(item => obj[item.key] = item.checked);

				return obj;
            },

            clearFilters() {
                this.diataryConstraints.forEach(constraint => constraint.checked = false);
                this.allergens.forEach(allergen => allergen.checked = false);
                this.maxCookingTime = 120;
                this.showFilters = false;
            },

            clearIngredients() {
                this.ingredients = [];
                this.showIngredientsSearch = false;
            },

            clearAll() {
                this.search = '';
                this.clearFilters();
                this.clearIngredients();
            }
        },

		watch: {
			search() {
				this.updateRecipes();
				window.localStorage.setItem('recipes-search', this.search);
			},

			sortOrder() {
				this.updateRecipes();
				window.localStorage.setItem('recipes-sort-order', this.sortOrder);
			},

			diataryConstraintsStringified() {
                this.getRecipes();
                window.localStorage.setItem('recipes-diatary-constraints', this.diataryConstraintsStringified);
			},

			allergensStringified() {
                window.localStorage.setItem('recipes-allergens', this.allergensStringified);
            },

            maxCookingTime() {
                window.localStorage.setItem('recipes-max-cooking-time', this.maxCookingTime);
            },
            
            ingredientsStringified() {
                this.getRecipes();
                window.localStorage.setItem('recipes-ingredients', this.ingredientsStringified);
                this.$emit('ingredient-search-updated', this.ingredients.length > 0);
            },

			isLoggedIn() {
                console.log(this.isLoggedIn);
                this.getRecipes();
			}
		},

		activated() {
			this.searching = true;
            this.getRecipes();
            this.$emit('ingredient-search-updated', this.ingredients.length > 0);
        },
        
        mounted() {
            this.searching = true;
            this.getRecipes();
            this.$emit('ingredient-search-updated', this.ingredients.length > 0);
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

	.filters{
        position: relative;
		color: @main-background;
		border: 1px solid @main-background;
		border-top: none;
		padding: 12px 12px;
		margin-bottom: 10px;
        margin-top: -16px;
        background-color: rgba(227, 234, 235, 0.63);
        opacity: 1;
    }
    
    .ingredients-search  {
        position: relative;
        color: @main-background;
		border: 1px solid @main-background;
		padding: 12px 12px;
        margin-top: -16px;
        background-color: rgba(227, 234, 235, 0.63);
    }

    .ingredients-search-add  {
        border-left: none !important;
    }

    .close-section {
        position: absolute;
        top: 10px;
        right: 10px;
    }

	.filter-title {
		font-size: 12pt;
	}

	.selected {
		background-color: @main-background;
		color: @main-color !important;
	}

	.search-row {
        position: relative;

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
    
    .search-indicator {
        position: absolute;
        top: 10px;
        right: 150px;
        color: @main-background;
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

	.sort-order {
		color: @main-background;
		min-width: 82px !important;
		font-size: 12pt;
	}

	.sort-order:hover {
		cursor: pointer;
	}

	.ingredient-search {
		color: @main-background;
		font-size: 12pt;
	}

	.ingredient-search:hover {
		text-decoration: underline;
	}
    
    .btn-outline-light {
		border-color: @main-background;
        color: @main-background;
        background-color: @main-color;
    }
    

	.btn-outline-light:hover {
		background-color: @main-background;
		color: @main-color;
	}

	.btn-outline-light:active {
		background-color: @main-background-dark !important;
		border-color: @main-background-dark !important;
		color: @main-color !important;
    }
    
    .btn-outline-light:focus {
        background-color: @main-color !important;
		border-color: @main-background !important;
		color: @main-background !important;
    }

</style>