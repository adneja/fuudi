<template>
    <div class="recipe flex-center-start">
        <div class="recipe-container px-md-5 pt-md-4 p-3">
            <div class="container-fluid">
                <div class="row row-adjustment">
                    <div class="col-12 mb-md-4 mb-3">
                        
                        <RecipeDetails @rating-clicked="scrollToRatings" v-bind:id="parseInt(id)"></RecipeDetails>
                    </div>

                    <div class="col-lg-5 col-md-6 mb-md-4 mb-3">
                        <div class="font-l font-primary mb-2">Ingredients</div>
                        <RecipeIngredients v-bind:id="parseInt(id)"></RecipeIngredients>
                    </div>

                    <div class="col-lg-7 col-md-6 mb-md-4 mb-3">
                        <div class="font-l font-primary mb-2">Instructions</div>
                        <RecipeInstructions v-bind:id="parseInt(id)"></RecipeInstructions>
                    </div>

                    <div class="col-12" ref="ratings">
                        <div class="font-l font-primary mb-2">Ratings</div>
                        <RecipeRatings v-bind:id="parseInt(id)"></RecipeRatings>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>


<script>
    import RecipeDetails from '../components/RecipeDetails/RecipeDetails.vue';
    import RecipeIngredients from '../components/RecipeDetails/RecipeIngredients.vue';
    import RecipeInstructions from '../components/RecipeDetails/RecipeInstructions.vue';
    import RecipeRatings from '../components/RecipeDetails/RecipeRatings.vue';

    export default {
        name: 'recipe',

        props: {
            id: String
        },

        components: {
            RecipeDetails,
            RecipeIngredients,
            RecipeInstructions,
            RecipeRatings
        },

        methods: {
            scrollToRatings() {
                this.$refs.ratings.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/styles/custom.less";

    .recipe {
        padding-top: 48px;
    }
</style>