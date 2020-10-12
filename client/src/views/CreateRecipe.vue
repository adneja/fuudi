<template>
	<div class="createrecipe d-flex justify-content-center">
		<div class="createrecipe-container">
			<!-- Details -->
			<div class="list-group mb-4">
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
			<div class="list-group mb-4">
				<div class="list-group-item list-title">
					<i class="fas fa-pepper-hot mr-2"></i>
					<span>INGREDIENTS</span>
				</div>

				<div class="list-group-item">
					<div class="container-fluid">
						<div class="row">
							<div class="col-md-12 p-0">
								<div class="mb-2">
									<div class="text-muted"><small>Add your ingredients by selecting an item, an amount and a unit of measurement.</small></div>
								</div>

								<table>
									<thead>
										<tr>
											<td class="text-muted" style="width: 60%">Ingredient</td>
											<td class="text-muted" style="width: 20%">Amount</td>
											<td class="text-muted" style="width: 20%">Unit</td>
											<td style="width: 10%"></td>
										</tr>
									</thead>
									<tbody>
										<tr v-for="(ingredient, index) in ingredients" v-bind:key="index">
											<td>
												<input class="form-control" v-bind:value="ingredient.foodItem.name">
											</td>

											<td>
												<input class="form-control" v-model="ingredient.amount">
											</td>

											<td>
												<input class="form-control" v-bind:value="ingredient.measurement.name">
											</td>

											<td>
												<button class="btn btn-danger" v-on:click="removeIngredient(index)">
													<i class="fas fa-trash-alt"></i>
												</button>
											</td>
										</tr>
										<tr>
											<!-- Ingredient -->
											<td>
												<input 
													v-on:blur="unfocusFooditem" 
													ref="fooditem"
													v-model="foodItemSearch" 
													type="text" 
													class="form-control" 
													placeholder="New ingredient.."
													v-on:keyup.enter="selectFoodItem(markedFoodItem)"
													v-on:keyup.right.stop.prevent="markNextFoodItem"
													v-on:keyup.left.stop.prevent="markPreviousFoodItem">
											</td>

											<!-- Amount -->
											<td>
												<input 
													ref="amount" 
													v-model="newIngredient.amount" 
													type="number" 
													class="form-control" 
													placeholder=""
													v-on:keyup.enter="$refs.measurement.focus()">
											</td>

											<!-- Unit -->
											<td>
												<input 
													v-on:blur="unfocusMeasurement" 
													ref="measurement"
													v-model="measurementSearch" 
													type="text" 
													class="form-control" 
													placeholder=""
													v-on:keyup.enter="selectMeasurement(markedMeasurement)"
													v-on:keyup.right="markNextMeasurement"
													v-on:keyup.left="markPreviousMeasurement">
											</td>
											<td>
												<button class="btn btn-success" v-on:click="addIngredient">
													<i class="fas fa-plus"></i>
												</button>
											</td>
										</tr>
									</tbody>
								</table>

							</div>

							<div class="col-md-12 p-0">
								<div v-if="showFoodItemsResults" class="mt-3">
									<div class="text-muted mb-1">Select an ingredient:</div>
									<div class="search-results">
										<div class="d-flex justify-content-start flex-wrap" v-if="!foodItemsSearching">
											<div>
												<span 
													v-for="(foodItem, index) in foodItems"  
													v-bind:key="index" 
													class="badge badge-dark mr-1 pointer"
													v-on:click="selectFoodItem(foodItem)"
													v-bind:class="[markedFoodItem === foodItem ? 'underline' : '']">

													<span>{{foodItem.name}}</span>
												</span>
											</div>

											<div>
												<span 
													v-if="foodItemSearch.length > 0 && !foodItemsSearching && !foodItemExists"
													class="badge badge-success pointer"
													v-on:click="createFoodItem"
													v-bind:class="[!markedFoodItem ? 'underline' : '']">

													<i v-if="creatingFoodItem" class="fas fa-circle-notch"></i>
													<i v-else class="fas fa-plus-circle mr-1"></i>
													<span>Add '{{foodItemSearch.trim()}}'</span>
												</span>
											</div>
										</div>
										<div v-else>
											<span class="badge badge-dark">
												<span>Searching</span>
												<i class="fas fa-circle-notch fa-spin ml-1"></i>
											</span>
										</div>
									</div>
								</div>

								<div v-if="showMeasurementsResults"  class="mt-3">
									<div class="text-muted mb-1">Select a unit of measurement:</div>
									<div class="search-results">
										<div class="d-flex justify-content-start flex-wrap" v-if="!measurementsSearching">
											<div>
												<span 
													v-for="(measurement, index) in measurements"  
													v-bind:key="index" 
													class="badge badge-dark mr-1 pointer"
													v-on:click="selectMeasurement(measurement)"
													v-bind:class="[markedMeasurement.id === measurement.id ? 'underline' : '']">

													<span>{{measurement.name}}</span>
												</span>
											</div>

											<small class="text-muted" v-if="measurementSearch.length > 0 && !measurementsSearching && !measurementExists && measurements.length === 0">
												Can't find unit '{{measurementSearch}}'
											</small>
										</div>

										<div v-else>
											<span class="badge badge-dark">
												<span>Searching</span>
												<i class="fas fa-circle-notch fa-spin ml-1"></i>
											</span>
										</div>
									</div>
								</div>
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
							<div class="col-md-12 p-0">
								<div class="mb-2">
									<small class="text-muted">Writing instructions will make it easier for others to recreate your recipe!</small>
								</div>

								<table>
									<thead>
										<tr>
											<td style="width: 100%" class="text-muted"></td>
											<td></td>
										</tr>
									</thead>
									<tbody>
										<tr v-for="(instruction, index) in sortedInstructions" v-bind:key="index">
											<td>
												<div class="input-group">
													<div class="input-group-prepend">
														<button disabled title="Move" class="btn btn-dark">{{index + 1}}</button>
													</div>
													<input type="text" class="form-control" v-model="instruction.instruction">
													<div class="input-group-append" v-if="sortedInstructions.length > 1">
														<button title="Move" class="btn btn-dark"><i class="fas fa-grip-lines"></i></button>
													</div>
												</div>
											</td>
											<td>
												<button class="btn btn-danger" v-on:click="removeInstruction(index)">
													<i class="fas fa-trash-alt"></i>
												</button>
											</td>
										</tr>

										<tr>
											<td>
												<input 
													v-model="newInstruction.instruction" 
													type="text" 
													placeholder="New instruction.." 
													class="form-control"
													ref="instruction"
													v-on:keyup.enter="addInstruction">
											</td>
											<td>
												<button v-on:click="addInstruction" class="btn btn-success">
													<i class="fas fa-plus"></i>
												</button>
											</td>
										</tr>
									</tbody>
								</table>
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
				showFoodItemsResults: false,
				markedFoodItem: null,

				measurementTimeout: null,
				measurementSearch: '',
				measurements: [],
				measurementFocus: false,
				measurementsSearching: false,
				creatingMeasurement: false,
				showMeasurementsResults: false,
				markedMeasurement: null,

				creatingRecipe: false
			}
		},

		computed: {
			foodItemExists() {
				return this.foodItems.filter((foodItem) =>  {
					return this.foodItemSearch.toLowerCase().trim() === foodItem.name.toLowerCase().trim();
				}).length > 0;
			},

			measurementExists() {
				return this.measurements.filter((measurement) => {
					return this.measurementSearch.toLowerCase().trim() === measurement.name.toLowerCase().trim() || this.measurementSearch.toLowerCase().trim() === measurement.long_name.toLowerCase().trim();
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
					
					if(this.foodItems.length > 0) {
						this.markedFoodItem = this.foodItems[0];
					} else {
						this.markedFoodItem = null;
					}
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

					if(this.measurements.length > 0) {
						this.markedMeasurement = this.measurements[0];
					} else {
						this.markedMeasurement = null;
					}
					
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
					name: this.capitalize(this.foodItemSearch),
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
				console.log(foodItem);

				if(foodItem) {
					this.newIngredient.foodItem = foodItem;
					this.foodItems = [];
					this.foodItemSearch = foodItem.name;
					this.showFoodItemsResults = false;

					this.$refs.amount.focus();
				} else {
					this.createFoodItem();
				}

			},

			selectMeasurement(measurement) {
				this.newIngredient.measurement = measurement;
				this.measurements = [];
				this.measurementSearch = measurement.name;
				this.showMeasurementsResults = false;
				this.addIngredient();
			},

			addIngredient() {
				if(this.newIngredient.foodItem && this.newIngredient.measurement && this.newIngredient.amount) {
					this.ingredients.push(this.newIngredient);
					this.newIngredient = {
						foodItem: null,
						measurement: null,
						amount: null
					};

					this.foodItemSearch = '';
					this.measurementSearch = '';

					this.$refs.fooditem.focus();
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
				this.$nextTick(() => {
					if(!this.newIngredient.foodItem) {
						this.foodItemSearch = '';
					}
				});
				*/
			},

			unfocusMeasurement() {
				/*
				this.measurements = [];
				this.measurementSearch = '';
				*/
			},

			addInstruction() {
				if(this.newInstruction.instruction.trim().length > 0) {
					
					this.newInstruction.number = this.instructions.length + 1;
					this.instructions.push(this.newInstruction);
					this.newInstruction = {
						number: null,
						instruction: ''
					};

					this.$refs.instruction.focus();
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
			},

			markNextFoodItem() {
				if(this.foodItems.length > 0) {
					if(this.markedFoodItem) {
						let currIndex = this.foodItems.indexOf(this.markedFoodItem);

						if(currIndex < (this.foodItems.length - 1)) {
							this.markedFoodItem = this.foodItems[currIndex + 1];
						} else {
							if(this.markedFoodItem) {
								this.markedFoodItem = null;
							} else {
								this.markedFoodItem = this.foodItems[0];
							}
						}
					} else  {
						this.markedFoodItem = this.foodItems[0];
					}
				}
			},

			markPreviousFoodItem() {
				if(this.foodItems.length > 1) {
					if(this.markedFoodItem) {
						let currIndex = this.foodItems.indexOf(this.markedFoodItem);

						if(currIndex > 0) {
							this.markedFoodItem = this.foodItems[currIndex - 1];
						} else {
							if(this.markedFoodItem) {
								this.markedFoodItem = null;
							} else {
								this.markedFoodItem = this.foodItems[this.foodItems.length - 1];
							}
						}
					} else {
						this.markedFoodItem = this.foodItems[this.foodItems.length - 1];
					}
				}
			},

			markNextMeasurement() {
				if(this.measurements.length > 1) {
					let currIndex = this.measurements.indexOf(this.markedMeasurement);

					if(currIndex < (this.measurements.length - 1)) {
						this.markedMeasurement = this.measurements[currIndex + 1];
					} else {
						this.markedMeasurement = this.measurements[0];
					}
				}
			},

			markPreviousMeasurement() {
				if(this.measurements.length > 1) {
					let currIndex = this.measurements.indexOf(this.markedMeasurement);

					if(currIndex > 0) {
						this.markedMeasurement = this.measurements[currIndex - 1];
					} else {
						this.markedMeasurement = this.measurements[this.measurements.length - 1];
					}
				}
			},

			capitalize(s) {
				let text = '';

				s.split(' ').forEach((word) => {
					text += word.charAt(0).toUpperCase() + word.slice(1).toLowerCase() + ' ';
				});

				return text.trim();
			}
		},

		watch: {
			foodItemSearch() {
				this.measurements = [];
				this.foodItemsSearching = true;
				
				if(this.newIngredient.foodItem) {
					if(this.newIngredient.foodItem.name !== this.foodItemSearch) {
						this.showFoodItemsResults = true;
					}
				} else {
					this.showFoodItemsResults = true;
				}

				if(this.foodItemSearch.trim().length === 0) {
					this.showFoodItemsResults = false;
				}

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

				if(this.newIngredient.measurement) {
					if(this.newIngredient.measurement.name !== this.measurementSearch) {
						this.showMeasurementsResults = true;
					}
				} else {
					this.showMeasurementsResults = true;
				}

				if(this.measurementSearch.trim().length === 0) {
					this.showMeasurementsResults = false;
				}

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
		padding: 6px 8px;
	}

	button {
		box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
		border: none;
	}

	.info {
		background-color: #c4bad325;
	}

	.underline {
		text-decoration: underline;
	}
</style>
