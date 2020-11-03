<template>
    <div class="reciperatings" v-if="ratings">
        <!--
        <Window title="Ratings" icon="fas fa-star">
            <RecipeRater @rated="updatedRatings => ratigns = updatedRatings" :max="5" :recipeId="id"/>
            <hr>
            <div v-for="(rating, index) in ratings" :key="index">
                <div class="flex-between-start">
                    <div class="font-m">{{rating.created_by_name}}</div>

                    <div class="text-right">
                        <Stars :stars="rating.rating" :max="5"/>
                        <div class="font-normal font-s">{{parseEpoch(rating.created_epoch)}}</div>
                    </div>
                </div>

                <div class="font-normal font-m">{{rating.comment}}</div>

                <hr v-if="index < ratings.length - 1">
            </div>
        </Window>
        -->
        <div class="card-inverted p-3 mb-2">
            <RecipeRater @rated="updatedRatings => ratigns = updatedRatings" :max="5" :recipeId="id"/>
        </div>

        <div v-for="(rating, index) in ratings" :key="index" class="card-inverted p-3 mb-2">
            <div class="flex-between-start">
                <div class="font-m">{{rating.created_by_name}}</div>

                <div class="text-right">
                    <Stars :stars="rating.rating" :max="5"/>
                    <div class="font-normal font-s">{{parseEpoch(rating.created_epoch)}}</div>
                </div>
            </div>

            <div class="font-normal font-m">{{rating.comment}}</div>
        </div>
    </div>
</template>

<script>
    import Placeholder from '../Placeholder.vue';
    import Window from '../Window.vue';
    import Stars from '../Stars.vue';
    import RecipeRater from '../RecipeRater.vue';

    import parseEpoch from '../../utils/parseEpoch.js';

    export default {
        name:'reciperatings',

        props: {
            id: Number
        },

        components: {
            Placeholder,
            Window,
            Stars,
            RecipeRater
        },

        data() {
            return {
                ratings: null
            }
        },

        methods: {
            getRatings() {
                this.$store.dispatch('recipesRatingsGet', {
                    id: this.id
                })
                .then((response) => {
                    this.ratings = response;
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            parseEpoch(epoch) {
                return parseEpoch(epoch);
            }
        },

        mounted() {
            this.getRatings();
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";
</style>