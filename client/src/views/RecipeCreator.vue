<template>
    <div class="recipecreator flex-center-start">
        <div class="recipecreator-content px-md-5 pt-md-4 p-3">
            <RecipeCreatorDetails ref="details" class="mb-4"/>
            <RecipeCreatorIngredients ref="ingredients" class="mb-4"/>
            <RecipeCreatorInstructions ref="instructions" class="mb-4"/>

            <div class="text-right">
                <button @click="create" class="btn btn-primary">Publish</button>
            </div>
        </div>
    </div>
</template>

<script>
    import RecipeCreatorDetails from '../components/RecipeCreator/RecipeCreatorDetails.vue';
    import RecipeCreatorIngredients from '../components/RecipeCreator/RecipeCreatorIngredients.vue';
    import RecipeCreatorInstructions from '../components/RecipeCreator/RecipeCreatorInstructions.vue';

    export default {
        name: 'recipecreator',

        components: {
            RecipeCreatorDetails,
            RecipeCreatorIngredients,
            RecipeCreatorInstructions
        },

        data() {
            return {
                details: {

                },

                ingredients: [],
                instructions: []
            }
        },

        methods: {
            create() {
                let details = this.$refs.details.getDetails(),
                    ingredients = this.$refs.ingredients.ingredients,
                    instructions = this.$refs.instructions.instructions;

                this.$store.dispatch('recipesInsert', {
                    name: details.title,
                    description: details.description,
                    cookingTime: details.cookingTime,
                    portions: details.portions,
                    fileId: details.fileId
                })
                .then((response) => {
                    // TODO: insert recipes and ingredients
                    /*
                    this.$store.dispatch('recipesInsertBulk', {
                        recipeId: response.id,
                        ingredients: ingredients
                    });

                    this.$store.dispatch('recipesInsertInstructions', {
                        recipeId: response.id,
                        instructions: instructions
                    });
                    */
                })
                .catch((err) => {
                    console.log(err);
                });

                console.log(details);
                console.log(ingredients);
                console.log(instructions);
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/styles/custom.less";

    .recipecreator {
        padding-top: 48px;
    }

    .recipecreator-content {
		width: 100%;
		max-width: @main-content-width;
    }
</style>