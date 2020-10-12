<template>
	<div class="createrecipe d-flex justify-content-center">
		<div class="createrecipe-container">
			<!-- Details -->
			<div class="list-group mb-5">
				<div class="list-group-item list-title">
					<i class="fas fa-info-circle mr-2"></i>
					<span>DETAILS</span>
				</div>
				<div class="list-group-item">
					<div class="container-fluid">
						<div class="row">
							<div class="col-md-5 pl-md-0 p-0 pr-md-3 mb-md-0 mb-3">
								<div class="border dashed rounded text-muted d-flex justify-content-center align-items-center h-100">
									<div class="text-center p-3 pointer" title="Click to upload image">
										<i class="fas fa-image fa-3x"></i>
										<div>Upload image</div>
									</div>
								</div>
							</div>

							<div class="col-md-7">
								<div class="row">
									<div class="col-12 p-0">
										<div class="mb-1 text-muted">Title</div>
										<input class="form-control mb-3" type="text" v-model="name">
									</div>
								</div>

								<div class="row">
									<div class="col-12 p-0">
										<div class="mb-1 text-muted">Description</div>
										<textarea class="form-control mb-3" type="text" rows="4" v-model="description"></textarea>
									</div>
								</div>

								<div class="row">
									<div class="col-md-6 p-md-0 pr-md-1 p-0">
										<div class="mb-1 text-muted">Cooking Time <small>(minutes)</small></div>
										<input v-model="cookingTime" class="form-control" type="number">
									</div>

									<div class="col-md-6 p-md-0 pl-md-1 p-0">
										<div class="mb-1 text-muted">Portions</div>
										<input v-model="portions" class="form-control" type="number">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Ingredients -->
			<div class="list-group mb-5">
				<div class="list-group-item list-title">
					<i class="fas fa-pepper-hot mr-2"></i>
					<span>INGREDIENTS</span>
				</div>

				<div class="list-group-item">
					<div class="container-fluid">
						<div class="row">
							<!-- Food item input -->
							<div class="col-md-7 mb-2 pl-md-0 pr-md-1 p-0">
								<div class="text-muted mb-1">Item</div>
								<input 
									v-on:blur="unfocusFooditem" 
									ref="fooditem" 
									v-if="!newIngredient.foodItem" 
									v-model="foodItemSearch" 
									type="text" 
									class="form-control" 
									placeholder="">
								
								<div v-else class="form-control d-flex justify-content-between">
									<div>
										<span class="badge badge-success">
											{{newIngredient.foodItem.name}}
										</span>
									</div>
									<span><i class="fas fa-times-circle pointer" v-on:click="clearFoodItems"></i></span>
								</div>
							</div>

							<!-- Amount input -->
							<div class="col-md-2 mb-2 px-md-1 p-0">
								<div class="text-muted mb-1">Amount</div>
								<input 
									ref="amount" 
									v-model="newIngredient.amount" 
									type="number" 
									class="form-control" 
									placeholder="">
							</div>

							<!-- Unit input -->
							<div class="col-md-2 mb-2 px-md-1 p-0">
								<div class="text-muted mb-1">Unit</div>
								<input 
									v-on:blur="unfocusMeasurement" 
									ref="measurement" 
									v-if="!newIngredient.measurement" 
									v-model="measurementSearch" 
									type="text" 
									class="form-control" 
									placeholder="">
								
								<div v-else class="form-control d-flex justify-content-between">
									<div>
										<span class="badge badge-success">
											{{newIngredient.measurement.name}}
										</span>
									</div>
									<span><i class="fas fa-times-circle pointer" v-on:click="clearMeasurements"></i></span>
								</div>
							</div>

							<div class="col-md-1 mb-2 pr-md-0 pl-md-1 p-0">
								<div class="mb-1 d-md-block d-none"><span v-html="'&nbsp;'"></span></div>
								<button v-on:click="addIngredient" class="btn btn-success w-100">
									<i class="fas fa-plus-circle mr-1"></i>
								</button>
							</div>
						</div>

						<!-- Measurement search results -->
						<div class="row" v-if="measurementSearch.length > 0 && !measurementsSearching">
							<div class="col p-0">
								<div class="card p-1 search-results">
									<div class="d-flex justify-content-start flex-wrap">
										<span 
											v-for="(measurement, index) in measurements"  
											v-bind:key="index" 
											class="badge badge-dark m-1 pointer"
											v-on:click="selectMeasurement(measurement)">

											<span>{{measurement.name}}</span>
										</span>

										<span 
											v-if="measurementSearch.length > 0 && !measurementsSearching && !measurementExists" 
											class="badge badge-success m-1 pointer">'
											
											<i class="fas fa-plus-circle mr-1"></i>
											<span>{{measurementSearch}}</span>
										</span>
									</div>
								</div>
							</div>
						</div>

						<!-- Food items search result -->
						<div class="row" v-if="foodItemSearch.length > 0 && !foodItemsSearching">
							<div class="col p-0">
								<div class="card p-1 search-results">
									<div class="d-flex justify-content-start flex-wrap">
										<span 
											v-for="(foodItem, index) in foodItems"  
											v-bind:key="index" 
											class="badge badge-dark m-1 pointer"
											v-on:click="selectFoodItem(foodItem)">

											<span>{{foodItem.name}}</span>
										</span>

										<span 
											v-if="foodItemSearch.length > 0 && !foodItemsSearching && !foodItemExists"
											class="badge badge-success m-1 pointer"
											v-on:click="createFoodItem">

											<i v-if="creatingFoodItem" class="fas fa-circle-notch"></i>
											<i v-else class="fas fa-plus-circle mr-1"></i>
											<span>{{foodItemSearch}}</span>
										</span>
									</div>
								</div>
							</div>
						</div>

						<div class="row" v-if="ingredients.length > 0">
							<div class="col p-0">
								<hr>
							</div>
						</div>

						<!-- Ingredients -->
						<div class="row" v-for="(ingredient, index) in ingredients" v-bind:key="index">
							<div class="col-md-7 col-7 mb-2 pl-md-0 pr-md-1 p-0">
								{{ingredient.foodItem.name}}
							</div>

							<div class="col-md-2 col-2 mb-2 px-md-1 p-0 pr-1 text-right">
								{{ingredient.amount}}
							</div>

							<div class="col-md-1 col-1 mb-2 px-md-1 p-0">
								{{ingredient.measurement.name}}
							</div>

							<div class="col-2 col-2 mb-2 px-md-1 p-0 text-right">
								<button v-on:click="removeIngredient(index)" title="Remove ingredient" class="btn btn-sm btn-danger"><i class="fas fa-times"></i></button>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Instructions -->
			<div class="list-group mb-4">
				<div class="list-group-item list-title">
					<i class="fas fa-list-ol mr-2"></i>
					<span>INSTRUCTIONS</span>
				</div>

				<div class="list-group-item">
					<div class="container-fluid">
						<div class="row">
							<div class="col-md-1 mb-2 pl-md-0 pr-md-1 p-0">
								<div class="text-muted mb-1">Order</div>
								<input 
									v-model="newInstruction.number" 
									type="number" 
									placeholder="" 
									class="form-control">
							</div>

							<div class="col-md-10 mb-2 px-md-1 p-0">
								<div class="text-muted mb-1">Instruction</div>
								<input 
									v-model="newInstruction.instruction" 
									type="text" 
									placeholder="" 
									class="form-control">
							</div>

							<div class="col-md-1 mb-2 pl-md-1 p-0 text-right">
								<div class="mb-1 d-md-block d-none"><span v-html="'&nbsp;'"></span></div>
								<button v-on:click="addInstruction" class="btn btn-success w-100">
									<i class="fas fa-plus-circle mr-1"></i>
								</button>
							</div>
						</div>

						<div class="row" v-if="instructions.length > 0">
							<div class="col-12 p-0">
								<hr>
							</div>
						</div>

						<div class="row" v-for="(instruction, index) in sortedInstructions" v-bind:key="index">
							<div class="col-md-11 col-11 mb-2 pl-md-0 pr-md-1 p-0">
								<span class="mr-2">{{instruction.number}}.</span>
								<span>{{instruction.instruction}}</span>
							</div>

							<div class="col-md-1 col-1 mb-2 px-md-1 p-0 text-right">
								<button 
									v-on:click="removeInstruction(index)" 
									class="btn btn-sm btn-danger">

									<i class="fas fa-times"></i>
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- Actions -->
			<div class="d-flex justify-content-end">
				<button 
					v-on:click="clear" 
					class="btn btn-danger mr-2">

					<span>Clear</span>
				</button>

				<button 
					v-on:click="createRecipe"
					class="btn btn-success">

					<i v-if="creatingRecipe" class="fas fa-circle-notch fa-spin"></i>
					<span v-else>Create</span>
				</button>
			</div>
		</div>
	</div>
</template>


<script>
	export default {
		name: 'CreateRecipe',
		
		data() {
			return {
				name: '',
				description: '',
				cookingTime: null,
				portions: null,
				ingredients: [],
				instructions: [],

				newIngredient: {
					foodItem: null,
					measurement: null,
					amount: null
				},

				newInstruction: {
					number: null,
					instruction: ''
				},
				
				foodItemTimeout: null,
				foodItemSearch: '',
				foodItems: [],
				foodItemFocus: false,
				foodItemsSearching: false,
				creatingFoodItem: false,

				measurementTimeout: null,
				measurementSearch: '',
				measurements: [],
				measurementFocus: false,
				measurementsSearching: false,
				creatingMeasurement: false,

				creatingRecipe: false
			}
		},

		computed: {
			foodItemExists() {
				return this.foodItems.filter((foodItem) =>  {
					return this.foodItemSearch.toLowerCase() === foodItem.name.toLowerCase();
				}).length > 0;
			},

			measurementExists() {
				return this.measurements.filter((measurement) => {
					return this.measurementSearch.toLowerCase() === measurement.name.toLowerCase() || this.measurementSearch.toLowerCase() === measurement.long_name.toLowerCase();
				}).length > 0;
			},

			sortedInstructions() {
				return this.instructions.sort((a, b) => {
					return a.number - b.number;
				});
			}
		},

		methods: {
			searchFoodItems() {
				this.$store.dispatch('searchFoodItems',  {
					search: this.foodItemSearch
				})
				.then((response) => {
					this.foodItems = response;
				})
				.catch((err) => {
					console.log(err);
				})
				.finally(() => {
					this.foodItemsSearching = false;
				});
			},

			searchMeasurements() {
				this.$store.dispatch('searchMeasurements',  {
					search: this.measurementSearch
				})
				.then((response) => {
					this.measurements = response;
				})
				.catch((err) => {
					console.log(err);
				})
				.finally(() => {
					this.measurementsSearching = false;
				});
			},

			createFoodItem() {
				this.creatingFoodItem = true;

				this.$store.dispatch('createFoodItem', {
					name: this.foodItemSearch,
					created_by: this.$store.getters.userData.id
				})
				.then((response) => {
					this.selectFoodItem(response);
				})
				.catch((err) => {
					console.log(err);
				})
				.finally(() => {
					this.creatingFoodItem = false;
				});
			},

			selectFoodItem(foodItem) {
				this.newIngredient.foodItem = foodItem;
				this.foodItems = [];
				this.foodItemSearch = '';
			},

			selectMeasurement(measurement) {
				this.newIngredient.measurement = measurement;
				this.measurements = [];
				this.measurementSearch = '';
			},

			addIngredient() {
				if(this.newIngredient.foodItem && this.newIngredient.measurement && this.newIngredient.amount) {
					this.ingredients.push(this.newIngredient);
					this.newIngredient = {
						foodItem: null,
						measurement: null,
						amount: null
					};
				}
			},

			removeIngredient(index) {
				this.ingredients.splice(index, 1);
			},

			clearFoodItems() {
				this.foodItems = [];
				this.foodItemSearch = '';
				this.newIngredient.foodItem = null;

				this.$nextTick(() => {
					this.$refs.fooditem.focus();
				});
			},

			clearMeasurements() {
				this.measurements = [];
				this.measurementSearch = [];
				this.newIngredient.measurement = null;

				this.$nextTick(() => {
					this.$refs.measurement.focus();
				});
			},

			unfocusFooditem() {
				/*
				this.foodItems = [];
				this.foodItemSearch = '';
				*/
			},

			unfocusMeasurement() {
				/*
				this.measurements = [];
				this.measurementSearch = '';
				*/
			},

			addInstruction() {
				if(this.newInstruction.number && this.newInstruction.instruction.trim().length > 0) {
					this.instructions.push(this.newInstruction);
					this.newInstruction = {
						number: null,
						instruction: ''
					};
				}
			},

			removeInstruction(index) {
				this.instructions.splice(index, 1);
			},

			createRecipe() {
				this.creatingRecipe = true;

				this.$store.dispatch('createRecipe', {
					name: this.name,
					description: this.description,
					cooking_time: this.cookingTime,
					portions: this.portions,
					ingredients: this.ingredients,
					instructions: this.instructions
				})
				.then((response) => {
					this.$store.commit('setSystemMessage', {
						content: 'Recipe created!',
						error: false
					});
				})
				.catch((err) => {
					this.$store.commit('setSystemMessage', {
						content: err,
						error: true
					});
				})
				.finally(() => {
					this.creatingRecipe = false;
				});
			},

			clear() {
				this.name = '';
				this.description = '';

				this.ingredients = [];
				this.instructions = [];
				this.newIngredient = {
					foodItem: null,
					amount: null,
					measurement: null
				};
				this.newInstruction = {
					number: null,
					instruction: ''
				}
			}
		},

		watch: {
			foodItemSearch() {
				this.measurements = [];
				this.foodItemsSearching = true;

				if(this.foodItemSearch.length > 0) {
					clearTimeout(this.foodItemTimeout);

					this.foodItemTimeout = setTimeout(() => {
						this.searchFoodItems();
					}, 500);
				} else {
					this.foodItems = [];
				}
			},

			measurementSearch() {
				this.foodItems = [];
				this.measurementsSearching = true;

				if(this.measurementSearch.length > 0) {
					clearTimeout(this.measurementTimeout);

					this.measurementTimeout = setTimeout(() => {
						this.searchMeasurements();
					}, 500);
				} else {
					this.measurements = [];
				}
			}
		}
	}
</script>


<style lang="less" scoped>
	@import "../assets/global.less";
	
	.createrecipe {
		padding-top: 50px;
	}

	.createrecipe-container {
		width: 100%;
		max-width: @main-content-width;
		padding: @main-padding-horizontal;
	}

	.list-group-item {
		padding: 20px;
		box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
		background-color: rgb(247, 243, 252);
		border: none !important;

		button {
			box-shadow: none;
		}
	}

	.list-title {
		background-color: @main-background !important;
		color: rgba(255, 255, 255, 0.6);
		padding: 7px 20px !important;
	}

	.badge {
		padding: 4px 6px;
	}

	button {
		box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
		border: none;
	}
</style>
