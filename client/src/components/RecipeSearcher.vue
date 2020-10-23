<template>
    <div class="recipesearcher" ref="recipesearcher">
        <div class="search-row input-group">
            <input v-model="search" class="form-control" placeholder="Search recipes">
            
            <button class="btn form-control-button d-flex justify-content-center align-items-center">
                <i v-if="searching" class="search-indicator fas fa-circle-notch fa-spin"></i>
                <i v-if="!searching && search.trim().length > 0" @click="search = ''" class="search-indicator fas fa-times-circle"></i>
            </button>

            <button 
                title="Show filters" 
                @click="showFilters = !showFilters" 
                class="btn btn-success filter-button">
                <i class="fas fa-filter"></i>
                <span v-if="numAppliedFilters > 0" class="filtercounter ml-1 muted">({{numAppliedFilters}})</span>    
            </button>
        </div>

        <!-- Side panel -->
        <transition name="slideIn">
            <div class="filter-sidepanel" v-if="showFilters">
                <div class="title d-flex justify-content-between align-items-center mb-4">
                    <div class=""><i class="fas fa-filter mr-2"></i>Filters</div>

                    <button class="btn textButton" @click="showFilters = false">
                        <i class="fas fa-times closeButton"></i>
                    </button>
                </div>
                
                <div class="filter-sidepanel-content">
                    <div class="filter-title mb-2 d-flex justify-content-between align-items-center">
                        <span>
                            <span>Ingredient search</span>
                            <span v-if="ingredients.length > 0" class="muted ml-2">({{ingredients.length}})</span>
                        </span>

                        <span v-if="ingredients.length > 0" class="clear pointer" title="Clear ingredients search" @click="clearIngredients">
                            <i class="fas fa-times-circle mr-1"></i>
                            <span>clear</span>
                        </span>
                    </div>

                    <SearchField
                        class="searchfield" 
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
                            <div class="col-6 px-0" v-for="i in Math.ceil(ingredients.length / 5)" v-bind:key="i">
                                <div class="mt-2" v-for="(ingredient, index) in ingredients.slice((i - 1) * 5, (i * 5))" v-bind:key="index">
                                    <i title="Remove" class="far fa-times-circle mr-1 pointer" @click="removeIngredient(ingredient)"></i>
                                    {{ingredient.name}}
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr>

                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-6 px-0">
                                <div class="mb-2 filter-title">Allergens</div>
                                <CheckboxCollection
                                    v-bind:checkboxItems="allergens"
                                    @change="items => allergens = items">
                                </CheckboxCollection>
                            </div>  

                            <div class="col-6 px-0">
                                <div class="mb-2 filter-title">Constraints</div>
                                <CheckboxCollection
                                    v-bind:checkboxItems="diataryConstraints"
                                    @change="items => diataryConstraints = items">
                                </CheckboxCollection>
                            </div>

                            <div class="col-12 px-0">
                                <hr>
                                <div class="filter-title d-flex justify-content-start align-items-center">
                                    <span>Max cooking time:</span>
                                    <span class="ml-1 normalFont font-weight-bold">
                                        <div class="cooking-time"  v-if="maxCookingTime >= 120">2h+</div>
                                        <div class="cooking-time" v-else>{{formattedCookingTime}}</div>
                                    </span>
                                </div>

                                <div class="slidecontainer">
                                    <input @change="updateRecipes" v-model="maxCookingTime" type="range" min="1" max="120" class="slider w-100" id="myRange">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="btn btn-outline-light w-100" @click="clearAll">
                    <span>Remove all</span>
                    <span v-if="numAppliedFilters > 0" class="muted ml-1">({{numAppliedFilters}})</span>
                </button>
            </div>
        </transition>
        <div v-if="showFilters" class="emptySpace" @click="showFilters = false"></div>
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
                console.log(ingredient);
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
                this.showFilters = false;
            },

            toggleFilters() {
                this.showFilters = !this.showFilters;
            }
        },

		watch: {
			search() {
                this.updateRecipes();
                console.log(this.search);
                console.log(this.searching);
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
                this.updateRecipes();
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
		font-size: 14pt;
	}

	.selected {
		background-color: @main-background;
        color: @main-color !important;
        
	}

	.search-row {
        position: relative;
        box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);

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
    }	
    
    .search-indicator {
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
		border-color: @main-color;
        color: @main-background;
        background-color: @main-color;
    }
    

	.btn-outline-light:hover {
		border-color: @main-color;
        color: @main-background;
        background-color: @main-color;
	}

	.btn-outline-light:active {
		border-color: @main-color;
        color: @main-background;
        background-color: @main-color;
        outline: none !important;
        
    }
    
    .btn-outline-light:focus {
		border-color: @main-color;
        color: @main-background;
        background-color: @main-color;
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

    .filter-button {
        //box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
        border: none !important;
    }

    .filter-sidepanel {
        position: fixed;
        top: 0px;
        left: 0px;
        width: 100%;
        max-width: 420px;
        height: 100%;
        max-height: 100vh;
        overflow-y: auto;
        background-color: @main-background;
        color: @main-color;
        z-index: 999999;
        box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
        padding: 20px;
    }

    .filter-sidepanel-content {
        //background-color: red;
        padding-top: 16px;
        height: 100%;
        max-height: calc(100% - 120px);
        overflow-y: auto;
        border-top: 1px solid @main-background-dark;
        border-bottom: 1px solid @main-background-dark;
        margin-bottom: 16px;
    }

    .title {
        font-size: 20pt;
        color: @main-color;

        button {
            width: 31px;
        }
    }

    .closeButton {
        font-size: 20pt;
    }

    .searchfield {
        color: @main-background;
    }

    .cooking-time {
        font-size: 12pt;
    }

    .slideIn-enter-active, .slideIn-leave-active {
		transition: margin 0.3s;
	}

	.slideIn-enter-from, .slideIn-leave-to {
        margin-left: -500px;
    }
    
    .emptySpace {
        position: fixed;
        top: 0px;
        right: 0px;
        width: 100%;
        z-index: 99999;
        height: 100vh;
    }

    .clear {
        font-size: 12pt;
    }

    .slideDown-enter-active, .slideDown-leave-active {
        transition: all 0.4s;
    }

    .slideDown-enter-from, .slideDown-leave-to {
        margin-top: -32px;
        opacity: 0;
    }
    
    .form-control-button {
        background-color: white;
        border: none !important;
    }

    .form-control-button:hover {
        background-color: white !important;
        color: @main-background !important;
    }
</style>