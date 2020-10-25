<template>
	<div class="createrecipe">
		<div class="details d-flex justify-content-center">
			<div class="details-container px-md-5 py-md-4 p-3 mb-md-2 mb-0">
				<div class="title"><i class="fas fa-utensils mr-2"></i>New Recipe</div>
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-4 mb-md-0 mb-3 mt-md-0 mt-2">
							<div class="h-100" v-bind:class="[!uploadedFile ? 'upload-image-container' : '']">
								<div 
									v-if="!uploadedFile" 
									class="text-center p-3 pointer" 
									@click="chooseFile"
									title="Click to upload image">
									
									<i v-if="!uploadingFile" class="fas fa-upload fa-2x"></i>
									<i v-else class="fas fa-circle-notch fa-3x fa-spin"></i>
									<div class="mt-2">Upload image</div>
								</div>

								<div v-else>
									<img class="recipe-image" ref="img" width="100%" v-bind:src="uploadedFilePath">
									
									<div class="btn-group w-100">
										<button 
											type="button"
											title="Remove image"
											class="w-50 btn btn-outline-light change-file-button"
											@click="removeFile">
											<i class="fas fa-trash-alt d-md-none d-inline"></i>
											<span class="d-md-inline d-none">Delete</span>
										</button>

										<button 
											type="button"
											title="Upload new image"
											@click="chooseFile" 
											class="w-50 btn btn-outline-light  change-file-button">
											<i class="fas fa-upload d-md-none d-inline"></i>
											<span class="d-md-inline d-none">Change</span>
										</button>
									</div>
								</div>
							</div>
						</div>

						<div class="col-md-8">
							<div class="row">
								<div class="col-12">
									<div class="mb-1 ">Title</div>
									<input class="form-control  mb-3" type="text" v-model="name" placeholder="">
								</div>
							</div>

							<div class="row">
								<div class="col-12">
									<div class="mb-1 ">Description</div>
									<textarea class="form-control  mb-3" rows="4" v-model="description"></textarea>
								</div>
							</div>

							<div class="row">
								<div class="col-md-6 mb-3">
									<div class="mb-1 ">Cooking Time <small>(minutes)</small></div>
									<input placeholder="" v-model="cookingTime" class="form-control " type="number">
								</div>

								<div class="col-md-6 mb-3">
									<div class="mb-1 ">Portions</div>
									<input placeholder="" v-model="portions" class="form-control " type="number">
								</div>
							</div>

							<div class="row">
								<div class="col-12 d-flex">
									<CheckboxCollection
										class="mb-2" 
										v-bind:checkboxItems="diataryConstraints"
										@change="items => diataryConstraints = items">
									</CheckboxCollection>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="d-flex justify-content-center extra-data">
		<div class="createrecipe-container px-md-5 py-md-4 px-2 pt-3">
			<Window title="Ingredients" icon="fas fa-pepper-hot" class="mb-md-4 mb-3">
				<div class="container-fluid">
					<!-- Data -->
					<div 
						class="row" 
						v-bind:class="[index === ingredients.length - 1 ? 'mb-2' : 'mb-md-2 mb-4']" 
						v-for="(ingredient, index) in ingredients" 
						v-bind:key="index">

						<div class="col-md-6 col-12 pr-md-1 mb-md-0 mb-2">
							<SearchField 
								action="searchFoodItems" 
								displayField="name"
								placeholder=""
								prompt="Change ingredient"
								v-bind:enableCreatePrompt="true"
								v-bind:bottomPadding="true"
								v-bind:startValue="ingredient.foodItem.name"
								@item-selected="updateFoodItem(index, $event)">
							</SearchField>
						</div>

						<div class="col-md-3 col-6 px-md-1 pr-1">
							<input class="form-control " v-model="ingredient.amount">
						</div>

						<div class="col-md-3 col-6 d-flex pl-md-1 pl-1">
							<SearchField 
								action="searchMeasurements" 
								displayField="name"
								placeholder=""
								prompt="Change unit"
								v-bind:bottomPadding="true"
								v-bind:startValue="ingredient.measurement.name"
								@item-selected="updateMeasurement(index, $event)">
							</SearchField>

							<button class="btn btn-outline-light  ml-2" @click="removeIngredient(index)">
								<i class="fas fa-trash-alt"></i>
							</button>
						</div>
					</div>

					<hr v-if="ingredients.length > 0">

					<!-- Input -->
					<div class="row">
						<div class="col-md-6 col-12 pr-md-1 mb-md-0 mb-3">
							<SearchField 
								ref="searchfooditems"
								action="searchFoodItems" 
								displayField="name"
								placeholder="Ingredient"
								prompt="Select ingredient"
								v-bind:enableCreatePrompt="true"
								@item-selected="selectFoodItem"
								@create-item="createFoodItem">
							</SearchField>	
						</div>

						<div class="col-md-3 col-6 px-md-1 pr-1">
							<input 
								ref="amount" 
								v-model="newIngredient.amount" 
								type="number" 
								class="form-control" 
								placeholder="Amount"
								@keyup.enter="$refs.searchmeasurements.focus()">
						</div>

						<div class="col-md-3 col-6 d-flex pl-md-1 pl-1">
							<SearchField
								ref="searchmeasurements" 
								action="searchMeasurements" 
								displayField="name"
								placeholder="Unit"
								prompt="Select unit"
								@item-selected="selectMeasurement">
							</SearchField>	

							<button class="btn btn-outline-light ml-2" @click="addIngredient">
								<i class="fas fa-plus"></i>
							</button>
						</div>
					</div>
				</div>
			</Window>

			<Window title="Instructions" icon="fas fa-list-ol " class="mb-md-4 mb-3">
				<div class="container-fluid">
					<!-- Data -->
					<div class="row mb-2" v-for="(instruction, index) in sortedInstructions" v-bind:key="index">
						<div class="col-12 d-flex">
							<div class="input-group">
								<div class="input-group-prepend">
									<button title="Move" class="btn order-button  btn-outline-light">{{index + 1}}</button>
								</div>
								<input type="text" class="form-control  " v-model="instruction.instruction">
								<div class="input-group-append" v-if="sortedInstructions.length > 1">
									<button 
										title="Move down" 
										class="btn  btn-outline-light"
										@click="moveInstructionDown(index)">

										<i class="fas fa-caret-down"></i>
									</button>
									<button 
										title="Move up" 
										class="btn  btn-outline-light"
										@click="moveInstructionUp(index)">

										<i class="fas fa-caret-up"></i>
									</button>
								</div>
							</div>

							<button class="btn  btn-outline-light ml-2" @click="removeInstruction(index)">
								<i class="fas fa-trash-alt"></i>
							</button>
						</div>
					</div>

					<hr v-if="instructions.length > 0">

					<!-- Inputs -->
					<div class="row">
						<div class="col-12 d-flex">
							<input 
								v-model="newInstruction.instruction" 
								type="text" 
								placeholder="Instruction" 
								class="form-control  "
								ref="instruction"
								@keyup.enter="addInstruction">

							<button @click="addInstruction" class="btn  btn-outline-light ml-2">
								<i class="fas fa-plus"></i>
							</button>
						</div>
					</div>
				</div>
			</Window>

			<Window class="mb-4" title="Allergens" icon="fas fa-exclamation-triangle ">
				<CheckboxCollection
					class="mb-2" 
					v-bind:checkboxItems="allergens"
					@change="items => allergens = items">
				</CheckboxCollection>
			</Window>

			<!-- Actions -->
			<div class="d-flex justify-content-md-end justify-content-center">
				<button 
					@click="createRecipe"
					class="btn btn-success">

					<i v-if="creatingRecipe" class="fas fa-circle-notch fa-spin"></i>
					<span v-else><i class="fas fa-check mr-2"></i>Create recipe</span>
				</button>
			</div>

			<input 
				@change="handleFileChange" 
				accept="image/*" 
				class="file invisible" 
				ref="file" 
				type="file"
				name="recipe">
		</div>
		</div>
	</div>
</template>


<script>
	import SearchField from '../components/SearchField.vue';
	import Window from '../components/Window.vue';
	import CheckboxCollection from '../components/CheckboxCollection.vue';
	import checkboxItems from '../utils/checkboxItems.js';

	export default {
		name: 'CreateRecipe',

		components: {
			SearchField,
			Window,
			CheckboxCollection
		},
		
		data() {
			return {
				name: '',
				description: '',
				cookingTime: null,
				portions: null,
				fileId: null,

				diataryConstraints: checkboxItems.diataryConstraints,
				allergens: checkboxItems.allergens,
				
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
				return `http://10.0.0.34:3333/api/files/img/${this.uploadedFile}`;
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

			checkboxArrayToObject(array) {
				let obj = {};

				array.forEach(item => obj[item.key] = item.checked);

				return obj;
			},

			createRecipe() {
				this.creatingRecipe = true;
				let diataryConstraints = this.checkboxArrayToObject(this.diataryConstraints),
					allergens = this.checkboxArrayToObject(this.allergens);

				this.$store.dispatch('createRecipe', {
					name: this.name,
					description: this.description,
					cooking_time: this.cookingTime,
					file_id: this.fileId,

					diatary_constraints: diataryConstraints,
					allergens: allergens,

					portions: this.portions,
					ingredients: this.ingredients,
					instructions: this.instructions
				})
				.then((response) => {
					this.$store.commit('setSystemMessage', {
						content: 'Recipe created!',
						error: false
					});

					this.$router.push({path: `/recipes/recipe/${response.id}`});
				})
				.catch((err) => {
					console.log(err);

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
		padding-top: 48px;
		background-color: rgba(227, 234, 235, 0.63);
		min-height: 100vh;
	}

	.createrecipe-container {
		width: 100%;
		max-width: @main-content-width;
	}

	.details-container {
		width: 100%;
		max-width: @main-content-width;
		color: @main-background;
	}

	.details {
		box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
		background-color: white;
	}

	.file {
		height: 0px;
		width: 0px;
	}

	.change-file-button {
		border-top-left-radius: 0rem;
		border-top-right-radius: 0rem;
	}

	.upload-image-container {
		border: 1px dashed @main-background;
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.order-button {
		width: 35px;
	}

	.container-fluid {
		padding: 0px;
	}

	input, textarea {
		border: 1px solid @main-background;
	}

	input:focus, textarea:focus {
		border: 1px solid @main-background !important;
	}

	.btn-outline-light {
		border-color: @main-background;
		color: @main-background;
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

	.title {
		font-size: 20pt;
		margin-bottom: 10px;
	}

	img {
		width: 100%;
		height: auto;
		margin-bottom: 10px;
	}
</style>