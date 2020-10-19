<template>
    <div class="recipesearcher">
        <div class="input-group search-row mb-3">
            <input v-model="search" class="form-control" placeholder="Search">
            <i class="search-indicator fas fa-circle-notch fa-spin"></i>

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
            <div class="mb-2 filter-title">Dietary constraints</div>
            <CheckboxCollection
                class="mb-2" 
                v-bind:checkboxItems="diataryConstraints"
                v-on:change="items => diataryConstraints = items">
            </CheckboxCollection>

            
            <div class="mb-2 filter-title">Exclude allergens</div>
            <CheckboxCollection
                class="mb-2" 
                v-bind:checkboxItems="allergens"
                v-on:change="items => allergens = items">
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
                <input v-on:change="getRecipes" v-model="maxCookingTime" type="range" min="1" max="120" value="120" class="slider w-100" id="myRange">
            </div>
        </div>

        <div class="d-flex justify-content-between">
            <!-- Ingredients search -->
            <span class="pointer ingredient-search">
                <i class="fas fa-search mr-1"></i>
                <span v-bind:class="[ingredients.lenght > 0 ? 'font-weight-bold' : '']">Search by Ingredients</span>
                <span v-if="ingredients.lenght > 0 " class="font-weight-bold">: {{ingredients.length}}</span>
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
</template>


<script>
	import CheckboxCollection from '../components/CheckboxCollection.vue';
    import checkboxItems from '../utils/checkboxItems.js';
    
    export default {
        name: 'RecipeSearcher',
        props: [],
        components: {CheckboxCollection},

        data() {
            return {
                search: '',
                sortOrder: 'popular',
                maxCookingTime: 120,
				diataryConstraints: checkboxItems.diataryConstraints,
                allergens: checkboxItems.allergens,
                ingredients: [],
                
                searchTimeout: null,
				searching: false,
				showFilters: false,
            }
        },

		computed: {
			numAppliedFilters() {
				let num = this.maxCookingTime < 120 ? 1 : 0;

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
			getRecipes() {
				this.$store.dispatch('getRecipes', {
					search: this.search,
					sort_order: this.sortOrder,
					diatary_constraints: JSON.stringify(this.checkboxArrayToObject(this.diataryConstraints)),
					allergens: JSON.stringify(this.checkboxArrayToObject(this.allergens)),
					max_cooking_time: this.maxCookingTime
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
				window.localStorage.setItem('recipe-search', this.search);
			},

			sortOrder() {
				this.updateRecipes();
				window.localStorage.setItem('recipe-sort-order', this.sortOrder);
			},

			diataryConstraintsStringified() {
				this.getRecipes();
			},

			allergensStringified() {
				this.getRecipes();
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

	.filters {
		color: @main-background;
		border: 1px solid @main-background;
		border-top: none;
		padding: 12px 12px;
		margin-bottom: 10px;
		margin-top: -16px;
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
        top: 0px;
        right: 0px;
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