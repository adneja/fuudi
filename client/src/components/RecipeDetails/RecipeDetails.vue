<template>
    <div class="recipedetails card-inverted relative" v-if="recipeInfo">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-6 p-0">
                    <img v-bind:src="imgURL">
                </div>

                <div class="col-md-6 p-md-4 p-3">
                    <div>
                        <div class="flex-between-start">
                            <div class="font-xl">{{recipeInfo.name}}</div>
                            <div class="flex-end-center cursor-underline cursor-pointer" @click="$emit('rating-clicked')">
                                <Stars v-bind:stars="recipeInfo.rating" max="5"></Stars>
                                <div class="font-faded font-normal font-s ml-1">({{recipeInfo.number_of_ratings}})</div>
                            </div>
                        </div>
                       
                        <div class="font-s">by {{recipeInfo.created_by_name}}</div>
                       
                        <hr>

                        <div class="mb-5 font-m font-italic font-normal">{{recipeInfo.description}}</div>

                        <!-- Action buttons -->
                        <div class="absolute-bottom-right p-md-4 p-3">
                            <button @click="toggleFavorite" class="btn btn-outline-primary mr-2">
                                <span v-if="!loadingFavorite">
                                    <i v-if="!recipeInfo.is_favorite" class="far fa-heart"></i>
                                    <i v-else class="fas fa-heart"></i>
                                </span>
                                <i v-else class="fas fa-circle-notch fa-spin"></i>

                                <span class="ml-2 d-md-inline d-none">
                                    <span>{{recipeInfo.is_favorite ? 'Remove from ' : 'Add to'}}</span> 
                                    <span> favorites</span>
                                </span>
                            </button>

                            <button @click="addToPlan" class="btn btn-outline-primary">
                                <i class="far fa-calendar-check"></i>
                                <span class="d-md-inline d-none ml-2">Add to meal plan</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Stars from '../Stars.vue';
    import Placeholder from '../Placeholder.vue';
    import parseEpoch from '../../utils/parseEpoch.js';

    export default {
        name:'recipedetails',

        props: {
            id: Number
        },

        components: {
            Stars,
            Placeholder
        },

        data() {
            return {
                recipeInfo: null,
                loadingFavorite: false
            }
        },

        computed: {
            imgURL() {
                return `${process.env.VUE_APP_REST_ADDR}/api/files/img/${this.recipeInfo.file_id}.${this.recipeInfo.file_mimetype.split('/')[1]}`;
            }
        },

        methods: {
            getRecipeInfo() {
                this.$store.dispatch('recipesGet', {
                    id: this.id
                })
                .then((response) => {
                    this.recipeInfo = response[0];
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            toggleFavorite() {
                let action = this.recipeInfo.is_favorite ? 'usersRecipesDelete' : 'usersRecipesInsert';

                this.loadingFavorite = true;
                this.$store.dispatch(action, {
                    recipeId: this.id
                })
                .then((response) => {
                    this.recipeInfo = response[0];
                    this.$store.commit('setSystemMessage', {
                        content: `Recipe ${response[0].is_favorite ? 'added to' : 'removed from'} favorites`,
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
                    this.loadingFavorite = false;
                });
            },

            parseEpoch(epoch) {
                return parseEpoch(epoch);
            },
        },

        mounted() {
            this.getRecipeInfo();
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";

    img {
        height: 320px;
        width: 100%;
        object-fit: cover;
    }
</style>