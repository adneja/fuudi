<template>
	<div class="createrecipe">
		<div class="details d-flex justify-content-center">
			<div class="details-container px-md-5 py-md-4 p-4">
				<div class="container-fluid">
					<div class="row">
						<div class="col-md-4 mb-md-0 mb-3 mt-md-0 mt-2">
							<div class="h-100" v-bind:class="[!uploadedFile ? 'uploadImageContainer' : '']">
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
											class="w-50 btn btn-outline-light changeFileButton"
											v-on:click="removeFile">
											<i class="fas fa-trash-alt d-md-none d-inline"></i>
											<span class="d-md-inline d-none">Delete</span>
										</button>

										<button 
											type="button"
											title="Upload new image"
											v-on:click="chooseFile" 
											class="w-50 btn btn-outline-light  changeFileButton">
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
									<textarea placeholder="" class="form-control  mb-3" type="text" rows="4" v-model="description"></textarea>
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
								<div class="col-12 d-flex flex-wrap">
									<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="vegan = !vegan">
										<div class="cb">
											<i v-if="vegan" class="fas fa-check"></i>
										</div>
										<span class="cb-label">Vegan</span>
									</div>

									<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="vegetarian = !vegetarian">
										<div class="cb">
											<i v-if="vegetarian" class="fas fa-check"></i>
										</div>
										<span class="cb-label">Vegetarian</span>
									</div>

									<div class="cb-container pointer mr-3" v-on:click="glutenFree = !glutenFree">
										<div class="cb">
											<i v-if="glutenFree" class="fas fa-check"></i>
										</div>
										<span class="cb-label">Gluten Free</span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="d-flex justify-content-center">
		<div class="createrecipe-container px-md-5 py-md-4 p-0">
			<Window title="Ingredients" icon="fas fa-pepper-hot" class="mb-md-4 mb-0">
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
								v-on:item-selected="updateFoodItem(index, $event)">
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
								v-on:item-selected="updateMeasurement(index, $event)">
							</SearchField>

							<button class="btn btn-outline-light  ml-2" v-on:click="removeIngredient(index)">
								<i class="fas fa-trash-alt"></i>
							</button>
						</div>
					</div>

					<hr v-if="ingredients.length > 0">

					<!-- Input -->
					<div class="row">
						<div class="col-md-6 col-12 pr-md-1 mb-md-0 mb-2">
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
						</div>

						<div class="col-md-3 col-6 px-md-1 pr-1">
							<input 
								ref="amount" 
								v-model="newIngredient.amount" 
								type="number" 
								class="form-control" 
								placeholder="Amount"
								v-on:keyup.enter="$refs.searchmeasurements.focus()">
						</div>

						<div class="col-md-3 col-6 d-flex pl-md-1 pl-1">
							<SearchField
								ref="searchmeasurements" 
								action="searchMeasurements" 
								displayField="name"
								placeholder="Unit"
								prompt="Select unit"
								v-on:item-selected="selectMeasurement">
							</SearchField>	

							<button class="btn btn-outline-light ml-2" v-on:click="addIngredient">
								<i class="fas fa-plus"></i>
							</button>
						</div>
					</div>
				</div>
			</Window>

			<Window title="Instructions" icon="fas fa-list-ol " class="mb-md-4 mb-0">
				<div class="container-fluid">
					<!-- Data -->
					<div class="row mb-2" v-for="(instruction, index) in sortedInstructions" v-bind:key="index">
						<div class="col-12 d-flex">
							<div class="input-group">
								<div class="input-group-prepend">
									<button title="Move" class="btn orderButton  btn-outline-light">{{index + 1}}</button>
								</div>
								<input type="text" class="form-control  " v-model="instruction.instruction">
								<div class="input-group-append" v-if="sortedInstructions.length > 1">
									<button 
										title="Move down" 
										class="btn  btn-outline-light"
										v-on:click="moveInstructionDown(index)">

										<i class="fas fa-caret-down"></i>
									</button>
									<button 
										title="Move up" 
										class="btn  btn-outline-light"
										v-on:click="moveInstructionUp(index)">

										<i class="fas fa-caret-up"></i>
									</button>
								</div>
							</div>

							<button class="btn  btn-outline-light ml-2" v-on:click="removeInstruction(index)">
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
								v-on:keyup.enter="addInstruction">

							<button v-on:click="addInstruction" class="btn  btn-outline-light ml-2">
								<i class="fas fa-plus"></i>
							</button>
						</div>
					</div>
				</div>
			</Window>

			<Window class="mb-4" title="Allergens" icon="fas fa-exclamation-triangle ">
				<div class="container-fluid">
					<div class="row">
						<div class="col-12 d-flex flex-wrap">
							<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="milk = !milk">
								<div class="cb">
									<i v-if="milk" class="fas fa-check"></i>
								</div>
								<span class="cb-label">Milk</span>
							</div>

							<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="egg = !egg">
								<div class="cb">
									<i v-if="egg" class="fas fa-check"></i>
								</div>
								<span class="cb-label">Egg</span>
							</div>

							<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="nuts = !nuts">
								<div class="cb">
									<i v-if="nuts" class="fas fa-check"></i>
								</div>
								<span class="cb-label">Nuts</span>
							</div>

							<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="wheat = !wheat">
								<div class="cb">
									<i v-if="wheat" class="fas fa-check"></i>
								</div>
								<span class="cb-label">Wheat</span>
							</div>

							<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="soy = !soy">
								<div class="cb">
									<i v-if="soy" class="fas fa-check"></i>
								</div>
								<span class="cb-label">Soy</span>
							</div>

							<div class="cb-container pointer mr-3 mb-md-0 mb-2" v-on:click="fish = !fish">
								<div class="cb">
									<i v-if="fish" class="fas fa-check"></i>
								</div>
								<span class="cb-label">Fish</span>
							</div>

							<div class="cb-container pointer" v-on:click="shellfish = !shellfish">
								<div class="cb">
									<i v-if="shellfish" class="fas fa-check"></i>
								</div>
								<span class="cb-label">Shellfish</span>
							</div>
						</div>
					</div>
				</div>
			</Window>

			<!-- Actions -->
			<div class="d-flex justify-content-md-end justify-content-center">
				<button 
					v-on:click="createRecipe"
					class="btn btn-success">

					<i v-if="creatingRecipe" class="fas fa-circle-notch fa-spin"></i>
					<span v-else>Create recipe!</span>
				</button>
			</div>

			<input 
				v-on:change="handleFileChange" 
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
		padding-top: 48px;
	}

	.createrecipe-container {
		width: 100%;
		max-width: @main-content-width;
	}

	@media screen and (max-width: 750px) {
		.createrecipe-container {
			width: calc(100vw + 3px) !important;
			margin-left: -1px !important;
			margin-right: -3px !important;
		}
	}

	.details-container {
		width: 100%;
		max-width: @main-content-width;
		color: @main-background;
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

	.uploadImageContainer {
		border: 1px dashed @main-background;
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.orderButton {
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
		font-size: 16pt;
	}
</style>