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
        
        <div class="filters lightblue" v-if="showFilters">
            <div class="mb-2 filter-title">Dietary constraints</div>
            <i title="Close" @click="showFilters = false" class="close-section pointer fas fa-times"></i>

            <CheckboxCollection
                class="mb-2" 
                v-bind:checkboxItems="diataryConstraints"
                @change="items => diataryConstraints = items">
            </CheckboxCollection>

            
            <div class="mb-2 filter-title">Exclude allergens</div>
            <CheckboxCollection
                class="mb-2" 
                v-bind:checkboxItems="allergens"
                @change="items => allergens = items">
            </CheckboxCollection>

            <!-- Max cooking time -->
            <div class="filter-title">
                <span>Max cooking time:</span>
                <span class="ml-1 normalFont font-weight-bold">
                    <span v-if="maxCookingTime >= 120">2h+</span>
                    <span v-else>{{formattedCookingTime}}</span>
                </span>
            </div>

            <div class="slidecontainer">
                <input @change="getRecipes" v-model="maxCookingTime" type="range" min="1" max="120" value="120" class="slider w-100" id="myRange">
            </div>
        </div>

        <div class="d-flex justify-content-between">
            <!-- Ingredients search -->
            <span class="pointer ingredient-search" @click="showIngredientsSearch = !showIngredientsSearch">
                <i class="fas fa-search mr-1"></i>
                <span>Search by Ingredients</span>
                <span v-if="ingredients.length > 0" class="muted"> ({{ingredients.length}})</span>
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
    
        <div class="ingredients-search mt-2 lightblue" v-if="showIngredientsSearch">
            <div class="mb-2 normalFont">
                <small>Searching by ingredients allow you to find recipes that uses ingredients you already have.</small>
            </div>

            <i @click="showIngredientsSearch = false" class="close-section pointer fas fa-times"></i>

            <SearchField 
                ref="searchfooditems"
                action="searchFoodItems" 
                displayField="name"
                placeholder="Ingredient.."
                prompt="Select ingredient"
                v-bind:enableCreatePrompt="true"
                @item-selected="addSearchIngredient">
            </SearchField>	

            <div v-for="(ingredient, index) in ingredients" v-bind:key="index" class="mt-2">
                <i title="Close" class="fas fa-times-circle mr-2 pointer" @click="removeIngredient(index)"></i>{{ingredient.name}}
            </div> 
        </div>
    </div>
</template>


<script>
    import CheckboxCollection from '../components/CheckboxCollection.vue';
    import SearchField from '../components/SearchField.vue';
    import checkboxItems, { diataryConstraints } from '../utils/checkboxItems.js';
    
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
                showIngredientsSearch: false
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
            addSearchIngredient(ingredient) {
                this.ingredients.push(ingredient);
                
                this.$nextTick(() => {
                    this.$refs.searchfooditems.clear();
                });
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
                    ingredients: JSON.stringify(this.ingredients.map(i => i.id))
				})
				.then((response) => {
					this.$emit('updated', response);
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
                this.getRecipes();
                window.localStorage.setItem('recipes-allergens', this.allergensStringified);
            },
            
            ingredients() {
                this.getRecipes();
                window.localStorage.setItem('recipes-ingredients', JSON.stringify(this.ingredients));
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

	.filters{
        position: relative;
		color: @main-background;
		border: 1px solid @main-background;
		border-top: none;
		padding: 12px 12px;
		margin-bottom: 10px;
		margin-top: -16px;
    }
    
    .ingredients-search  {
        position: relative;
        color: @main-background;
		border: 1px solid @main-background;
		padding: 12px 12px;
		margin-bottom: 10px;
		margin-top: -16px;
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

	.btn-outline-light:focus, .btn-outline-light:active, .btn-outline-light:hover {
		background-color:@main-color !important;
		color: @main-background !important;
	}

	.btn-outline-light:active {
		background-color:@main-color !important;
		color: @main-background !important;
	}
</style>