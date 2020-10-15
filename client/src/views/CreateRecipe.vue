<template>
	<div class="createrecipe d-flex justify-content-center">
		<div class="createrecipe-container">
			<!-- Details -->
			<Window title="New recipe" icon="fas fa-info-circle" class="mb-5">
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-4 pl-md-0 p-0 pr-md-3 mb-md-0 mb-3 mt-md-0 mt-3">
							<div 
								v-bind:class="[!uploadedFile ? 'uploadImageContainer' : '']"
								class="d-flex justify-content-center align-items-center h-100">
								<div 
									v-if="!uploadedFile" 
									class="text-center p-3 pointer" 
									v-on:click="chooseFile"
									title="Click to upload image">
									
									<i v-if="!uploadingFile" class="fas fa-upload fa-2x"></i>
									<i v-else class="fas fa-circle-notch fa-3x fa-spin"></i>
									<div class="mt-2">Upload image</div>
								</div>

								<div v-else>
									<img class="recipeImage" ref="img" width="100%" v-bind:src="uploadedFilePath">
									
									<div class="btn-group w-100">
										<button 
											type="button"
											title="Remove image"
											class="w-50 btn btn-sm btn-outline-light changeFileButton"
											v-on:click="removeFile">
											<i class="fas fa-trash-alt d-md-none d-inline"></i>
											<span class="d-md-inline d-none">Delete</span>
										</button>

										<button 
											type="button"
											title="Upload new image"
											v-on:click="chooseFile" 
											class="w-50 btn btn-sm btn-outline-light  changeFileButton">
											<i class="fas fa-upload d-md-none d-inline"></i>
											<span class="d-md-inline d-none">Change</span>
										</button>
									</div>
								</div>
							</div>
						</div>

						<div class="col-md-8">
							<div class="row">
								<div class="col-12 p-0">
									<div class="mb-1 muted">Title</div>
									<input class="form-control form-control-sm mb-3" type="text" v-model="name" placeholder="">
								</div>
							</div>

							<div class="row">
								<div class="col-12 p-0">
									<div class="mb-1 muted">Description</div>
									<textarea placeholder="" class="form-control form-control-sm mb-3" type="text" rows="4" v-model="description"></textarea>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6 p-md-0 pr-md-1 p-0 mb-3">
									<div class="mb-1 muted">Cooking Time <small>(minutes)</small></div>
									<input placeholder="" v-model="cookingTime" class="form-control form-control-sm" type="number">
								</div>

								<div class="col-md-6 p-md-0 pl-md-1 p-0 mb-3">
									<div class="mb-1 muted">Portions</div>
									<input placeholder="" v-model="portions" class="form-control form-control-sm " type="number">
								</div>
							</div>

							<div class="row">
								<div class="col-12 p-0 d-flex flex-wrap">
									<div class="custom-control custom-checkbox mr-3">
										<input v-model="vegan" type="checkbox" class="custom-control-input" id="vegan">
										<label class="custom-control-label" for="vegan">
											<span class="muted">Vegan</span>
										</label>
									</div>
									<div class="custom-control custom-checkbox mr-3">
										<input v-model="vegetarian" type="checkbox" class="custom-control-input" id="vegetarian">
										<label class="custom-control-label " for="vegetarian">										
											<span class="muted">Vegetarian</span>
										</label>
									</div>

									<div class="custom-control custom-checkbox mr-3">
										<input v-model="glutenFree" type="checkbox" class="custom-control-input" id="gluten">
										<label class="custom-control-label " for="gluten">
											<span class="muted">Gluten free</span>
										</label>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</Window>

			<!-- Ingredients -->
			<Window title="Ingredients" icon="fas fa-pepper-hot" class="mb-5">
				<table>
					<thead class="invisible">
						<tr>
							<td class=" " style="width: 60%"></td>
							<td class="amountPadding" style="width: 20%"></td>
							<td class=" " style="width: 20%"> <!--<i title="Unit of measurement (e.g. tbsp)" class="pointer far fa-question-circle"></i>--></td>
							<td></td>
						</tr>
					</thead>
					<tbody>
						<!-- Data -->
						<tr v-for="(ingredient, index) in ingredients" v-bind:key="index">
							<td>
								<SearchField 
									action="searchFoodItems" 
									displayField="name"
									placeholder=""
									prompt="Change ingredient"
									v-bind:enableCreatePrompt="true"
									v-bind:bottomPadding="true"
									v-bind:startValue="ingredient.foodItem.name"
									v-on:item-selected="updateFoodItem(index, $event)">
								</SearchField>
							</td>

							<td class="amountPadding">
								<input class="form-control form-control-sm " v-model="ingredient.amount">
							</td>

							<td class="unitSpacing">
								<SearchField 
									action="searchMeasurements" 
									displayField="name"
									placeholder=""
									prompt="Change unit"
									v-bind:bottomPadding="true"
									v-bind:startValue="ingredient.measurement.name"
									v-on:item-selected="updateMeasurement(index, $event)">
								</SearchField>
							</td>

							<td>
								<button class="btn btn-outline-light btn-sm" v-on:click="removeIngredient(index)">
									<i class="fas fa-trash-alt"></i>
								</button>
							</td>
						</tr>

						<!-- Inputs -->
						<tr>
							<td>
								<SearchField 
									ref="searchfooditems"
									action="searchFoodItems" 
									displayField="name"
									placeholder="Ingredient"
									prompt="Select ingredient"
									v-bind:enableCreatePrompt="true"
									v-on:item-selected="selectFoodItem"
									v-on:create-item="createFoodItem">
								</SearchField>	
							</td>

							<td class="amountPadding">
								<input 
									ref="amount" 
									v-model="newIngredient.amount" 
									type="number" 
									class="form-control form-control-sm " 
									placeholder="Amount"
									v-on:keyup.enter="$refs.searchmeasurements.focus()">
							</td>

							<td class="unitSpacing">
								<SearchField
									ref="searchmeasurements" 
									action="searchMeasurements" 
									displayField="name"
									placeholder="Unit"
									prompt="Select unit"
									v-on:item-selected="selectMeasurement">
								</SearchField>	
							</td>
							<td>
								<button class="btn btn-outline-light btn-sm" v-on:click="addIngredient">
									<i class="fas fa-plus"></i>
								</button>
							</td>
						</tr>
						
					</tbody>
				</table>
			</Window>

			<!-- Instructions -->
			<Window title="Instructions" icon="fas fa-list-ol" class="mb-5">
				<table>
					<thead class="invisible">
						<tr>
							<td style="width: 100%" class="heightZero"></td>
							<td></td>
						</tr>
					</thead>

					<tbody>
						<!-- Data -->
						<tr v-for="(instruction, index) in sortedInstructions" v-bind:key="index">
							<td class="unitSpacing">
								<div class="input-group">
									<div class="input-group-prepend">
										<button title="Move" class="btn orderButton btn-sm btn-outline-light">{{index + 1}}</button>
									</div>
									<input type="text" class="form-control form-control-sm " v-model="instruction.instruction">
									<div class="input-group-append" v-if="sortedInstructions.length > 1">
										<button 
											title="Move down" 
											class="btn btn-sm btn-outline-light"
											v-on:click="moveInstructionDown(index)">

											<i class="fas fa-caret-down"></i>
										</button>
										<button 
											title="Move up" 
											class="btn btn-sm btn-outline-light"
											v-on:click="moveInstructionUp(index)">

											<i class="fas fa-caret-up"></i>
										</button>
									</div>
								</div>
							</td>
							<td>
								<button class="btn btn-sm btn-outline-light" v-on:click="removeInstruction(index)">
									<i class="fas fa-trash-alt"></i>
								</button>
							</td>
						</tr>

						<!-- Inputs -->
						<tr>
							<td class="unitSpacing">
								<input 
									v-model="newInstruction.instruction" 
									type="text" 
									placeholder="Instruction" 
									class="form-control form-control-sm "
									ref="instruction"
									v-on:keyup.enter="addInstruction">
							</td>
							<td>
								<button v-on:click="addInstruction" class="btn btn-sm btn-outline-light">
									<i class="fas fa-plus"></i>
								</button>
							</td>
						</tr>
					</tbody>
				</table>
			</Window>

			<Window class="mb-4" title="Allergens" icon="fas fa-exclamation-triangle">
				<div class="container-fluid">
					<div class="row">
						<div class="col-12 p-0 d-flex flex-wrap">
							<div class="custom-control custom-checkbox mr-3">
								<input v-model="milk" type="checkbox" class="custom-control-input" id="milk">
								<label class="custom-control-label " for="milk">
									<span class="muted">Milk</span>
								</label>
							</div>

							<div class="custom-control custom-checkbox mr-3">
								<input v-model="egg" type="checkbox" class="custom-control-input" id="egg">
								<label class="custom-control-label " for="egg">
									<span class="muted">Egg</span>
								</label>
							</div>

							<div class="custom-control custom-checkbox mr-3">
								<input v-model="nuts" type="checkbox" class="custom-control-input" id="nuts">
								<label class="custom-control-label " for="nuts">
									<span class="muted">Nuts</span>
								</label>
							</div>

							<div class="custom-control custom-checkbox mr-3">
								<input v-model="wheat" type="checkbox" class="custom-control-input" id="wheat">
								<label class="custom-control-label " for="wheat">
									<span class="muted">Wheat</span>
								</label>
							</div>

							<div class="custom-control custom-checkbox mr-3">
								<input v-model="soy" type="checkbox" class="custom-control-input" id="soy">
								<label class="custom-control-label " for="soy">
									<span class="muted">Soy</span>
								</label>
							</div>

							<div class="custom-control custom-checkbox mr-3">
								<input v-model="fish" type="checkbox" class="custom-control-input" id="fish">
								<label class="custom-control-label " for="fish">
									<span class="muted">Fish</span>
								</label>
							</div>

							<div class="custom-control custom-checkbox mr-3">
								<input v-model="shellfish" type="checkbox" class="custom-control-input" id="shellfish">
								<label class="custom-control-label " for="shellfish">
									<span class="muted">Shellfish</span>
								</label>
							</div>
						</div>
					</div>
				</div>
			</Window>

			<!-- Actions -->
			<div class="d-flex justify-content-end">
				<button 
					v-on:click="createRecipe"
					class="btn btn-success shadow">

					<i v-if="creatingRecipe" class="fas fa-circle-notch fa-spin"></i>
					<span v-else>Create</span>
				</button>
			</div>

			<input 
				v-on:change="handleFileChange" 
				accept="image/*" 
				class="file" 
				ref="file" 
				type="file"
				name="recipe">
		</div>
	</div>
</template>


<script>
	import SearchField from '../components/SearchField.vue';
	import Window from '../components/Window.vue';

	export default {
		name: 'CreateRecipe',

		components: {
			SearchField,
			Window
		},
		
		data() {
			return {
				name: '',
				description: '',
				cookingTime: null,
				portions: null,
				fileId: null,

				vegan: false,
				vegetarian: false,
				glutenFree: false,
				milk: false,
				egg: false,
				nuts: false,
				wheat: false,
				soy: false,
				fish: false,
				shellfish: false,
				
				ingredients: [],
				newIngredient: {
					foodItem: null,
					measurement: null,
					amount: null
				},

				instructions: [],
				newInstruction: {
					number: null,
					instruction: ''
				},
				
				creatingRecipe: false,
				uploadingFile: false,
				uploadedFile: null
			}
		},

		computed: {
			sortedInstructions() {
				return this.instructions.sort((a, b) => {
					return a.number - b.number;
				});
			},

			uploadedFilePath() {
				return `http://localhost:3333/api/files/img/${this.uploadedFile}`;
			}
		},

		methods: {
			createFoodItem(name) {
				this.$store.dispatch('createFoodItem', {
					name: name,
					created_by: this.$store.getters.userData.id
				})
				.then((response) => {
					this.selectFoodItem(response);

					this.$store.commit('setSystemMessage', {
						content: 'New ingredient has been added to the database.',
						error: false
					});
				})
				.catch((err) => {
					this.$store.commit('setSystemMessage', {
						content: 'New ingredient has been added to the database.',
						error: err
					});
				});
			},

			selectFoodItem(foodItem) {
				if(foodItem) {
					this.newIngredient.foodItem = foodItem;
					this.$refs.amount.focus();
				} 
			},

			updateFoodItem(index, newFoodItem) {
				this.ingredients[index].foodItem = newFoodItem;
			},

			selectMeasurement(measurement) {
				this.newIngredient.measurement = measurement;
				this.addIngredient();
			},

			updateMeasurement(index, newMeasurement) {
				this.ingredients[index].measurement = newMeasurement;
			},

			addIngredient() {
				if(this.newIngredient.foodItem && this.newIngredient.measurement && this.newIngredient.amount) {
					this.ingredients.push(this.newIngredient);
					this.newIngredient = {
						foodItem: null,
						measurement: null,
						amount: null
					};

					this.$refs.searchfooditems.clear();
					
					this.$nextTick(() => {
						this.$refs.searchmeasurements.clear();
					});

					this.$refs.searchfooditems.focus();
				}
			},

			removeIngredient(index) {
				this.ingredients.splice(index, 1);
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

			moveInstructionUp(index) {
				if(index > 0) {
					this.instructions[index].number = (index - 1);
					this.instructions[index - 1].number = index;
				}
			},

			moveInstructionDown(index) {
				if(index < (this.instructions.length - 1))  {
					this.instructions[index].number = (index + 1);
					this.instructions[index + 1].number = index;
				}
			},

			createRecipe() {
				this.creatingRecipe = true;

				this.$store.dispatch('createRecipe', {
					name: this.name,
					description: this.description,
					cooking_time: this.cookingTime,
					file_id: this.fileId,

					vegan: this.vegan,
					vegetarian: this.vegetarian,
					gluten_free: this.glutenFree,

					allergen_milk: this.milk,
					allergen_egg: this.egg,
					allergen_nuts: this.nuts,
					allergen_wheat: this.wheat,
					allergen_soy: this.soy,
					allergen_fish: this.fish,
					allergen_shellfish: this.shellfish,

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
			
			chooseFile() {
                this.$refs.file.value = "";
                this.$refs.file.click();
			},
			
			handleFileChange() {
				let file = this.$refs.file.files[0],
					formData = new FormData();

				formData.append('file', file);
				this.uploadingFile = true;

				this.$store.dispatch('uploadFile', formData)
				.then((response) => {
					this.uploadedFile = response.path;
					this.fileId = response.id;

					this.$store.commit('setSystemMessage', {
						content: 'File uploaded!',
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
					this.uploadingFile = false;
				});
			},

			removeFile() {
				this.fileId = null;
				this.uploadedFile = null;
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

	td {
		vertical-align: top;
	}

	.file {
		height: 0px;
		width: 0px;
	}

	.changeFileButton {
		border-top-left-radius: 0rem;
		border-top-right-radius: 0rem;
	}

	.recipeImage {
		border-top-left-radius: 0.25rem;
		border-top-right-radius: 0.25rem;
	}

	
	table {
		border-collapse: separate;
		border-spacing: 0px 7px;
		margin-top: -7px;
	}


	.custom-control-label::before  {
		background-color: @main-background !important;
		border-color: @main-color;
	}

	.custom-control-input:checked~.custom-control-label::before  {
		background-color: @main-background !important;
		border-color: @main-color;
	}

	.custom-control-input:focus ~ .custom-control-label::before {
		box-shadow:none !important;
		outline: none !important;
		border-color: @main-color;
	}


	.uploadImageContainer {
		border: 1px dashed white;
		border-radius: 0.25rem;
	}

	.amountPadding {
		padding-left: 7px;
		padding-right: 7px;
	}

	.unitSpacing { 
		padding-right: 7px;
	}

	.window {
		margin-bottom: 30px !important;
	}

	.invisible {
		visibility: collapse !important;
	}

	.orderButton {
		width: 35px;
	}
</style>