<template>
    <div class="recipesearcher">
        <div class="search-row mb-3">
            <input v-model="search" class="form-control" placeholder="Search recipes">
            <i v-if="searching" class="search-indicator fas fa-circle-notch fa-spin"></i>
        </div>

        <div class="d-flex justify-content-between">
            <!-- Filters -->
            <span class="ingredient-search">
                <span class="pointer underline" @click="toggleFilters">
                    <span v-if="!showFilters">
                        <i class="fas fa-filter mr-1"></i>
                        <span>Show filters</span>
                        <span v-if="numAppliedFilters > 0" class="muted"> ({{numAppliedFilters}})</span>
                    </span>
                    <span v-else>
                        <i class="fas hide-logo fa-times mr-1"></i>
                        <span>Hide filters</span>
                        <span v-if="numAppliedFilters > 0" class="muted"> ({{numAppliedFilters}})</span>
                    </span>
                </span>

                <i v-if="numAppliedFilters > 0" class="fas fa-times-circle clear-logo pointer" title="Clear filters" @click.stop="clearAll"></i>
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

        <div class="filters" v-if="showFilters">
            <Window title="Filters" icon="fas fa-filter">
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
                        </div>
                    </div>
                </div>
            </Window>
        </div>


        <div class="ingredients-search mt-2" v-if="showFilters">
            <Window title="Search by ingredients" icon="fas fa-pepper-hot">
                <template v-slot:titlebar>
                    <div class="d-flex justify-content-end align-items-center">
                        <i title="Click to show info" class="fas fa-info-circle pointer" @click="showIngredientsInfo = !showIngredientsInfo"></i>
                    </div>
                </template>

                <div class="mb-2" v-if="showIngredientsInfo">
                    <small class="normalFont letter-spacing">Find recipes that uses ingredients you already have. Start typing in the field below and select your ingredients.</small>
                </div>

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
            </Window>
        </div>
    </div>
</template>


<script>
    import CheckboxCollection from '../components/CheckboxCollection.vue';
    import SearchField from '../components/SearchField.vue';
    import Window from '../components/Window.vue';
    import checkboxItems from '../utils/checkboxItems.js';
    import {nextTick} from 'vue';
    
    export default {
        name: 'RecipeSearcher',
        props: [],
        components: {CheckboxCollection, SearchField, Window},

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
                numOfResults: null,

                showIngredientsInfo: false
            }
        },

		computed: {
			numAppliedFilters() {
                let num = this.maxCookingTime < 120 ? 1 : 0;
                
                num += this.ingredients.length;
                
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
            },

            clearIngredients() {
                this.ingredients = [];
            },

            clearAll() {
                this.search = '';
                this.clearFilters();
                this.clearIngredients();
            },

            toggleFilters() {
                this.showFilters = !this.showFilters;
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
                console.log('test');
                this.updateRecipes();
                window.localStorage.setItem('recipes-diatary-constraints', this.diataryConstraintsStringified);
			},

			allergensStringified() {
                this.updateRecipes();
                window.localStorage.setItem('recipes-allergens', this.allergensStringified);
            },

            maxCookingTime() {
                window.localStorage.setItem('recipes-max-cooking-time', this.maxCookingTime);
            },
            
            ingredientsStringified() {
                this.updateRecipes();
                window.localStorage.setItem('recipes-ingredients', this.ingredientsStringified);
                this.$emit('ingredient-search-updated', this.ingredients.length > 0);
            },

			isLoggedIn() {
                console.log(this.isLoggedIn);
                this.updateRecipes();
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
        margin-bottom: 16px;
        margin-top: 16px;
        opacity: 1;
    }
    
    .ingredients-search  {
        position: relative;
        color: @main-background;
        margin-top: -16px;
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
        top: 9px;
        right: 8px;
        font-size: 16pt;
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

    .hide-logo {
        font-size: 14pt;
    }

    .clear-logo {
        font-size: 11pt;
        margin-left: 5px;
    }

    .show-filters {
        background-color: @main-background;
    }

</style>