<template>
    <div class="recipe">
        <div class="d-flex justify-content-center">
            <div class="recipe-container px-md-5 pt-md-4 px-0 pt-0">
                <div class="details">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-6 p-0">
                                <Placeholder v-if="!recipeInfo" height="320px" v-bind:amount="1" v-bind:spacing="0"></Placeholder>
                                <img v-else v-bind:src="imgURL" width="100%">
                            </div>

                            <div class="col-md-6 p-md-4 p-3">
                                <div v-if="!recipeInfo">
                                    <Placeholder height="50px" v-bind:amount="1" v-bind:spacing="30"></Placeholder>
                                    <Placeholder height="20px" v-bind:amount="4" v-bind:spacing="10"></Placeholder>
                                </div>

                                <div v-else>
                                    <div class="d-flex justify-content-between">
                                        <div class="title">{{recipeInfo.name}}</div>
                                        <span class="d-flex justify-content-start align-items-center">
                                            <Stars v-bind:stars="recipeInfo.rating" max="5"></Stars>
                                            <span class="number-of-ratings muted ml-2">({{recipeInfo.number_of_ratings}})</span>
                                        </span>
                                    </div>

                                    <div class="d-flex justify-content-start align-items-center mb-3">
                                        <div>
                                            <div class="author">By {{recipeInfo.created_by}}</div>
                                            <div class="normalFont muted date letter-spacing">{{timeFromEpoch(recipeInfo.created_epoch)}}</div>
                                        </div>
                                    </div>
                                
                                    <div class="normalFont description letter-spacing">{{recipeInfo.description}}</div>

                                    <div class="action-buttons p-md-4 p-3">
                                        <span class="pointer mr-2" @click="addToFavorites">
                                            <i title="Add to favorites" v-if="!recipeInfo.is_bookmarked" class="far fa-heart"></i>
                                            <i title="Remove from favorites" v-else class="fas fa-heart"></i>
                                        </span>

                                        <span class="pointer" @click="addToPlan">
                                            <i title="Add to mealplan" class="far fa-calendar-check"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-center">
            <div class="recipe-container px-md-5 py-md-4 px-3 py-3">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-5 col-md-6 px-0 pr-md-3 mb-md-3 mb-3">
                            <div class="ingredients-container">
                                <Placeholder v-if="!ingredients" height="25px" v-bind:amount="8" v-bind:spacing="15"></Placeholder>
                                
                                <Window v-else title="Ingredients" icon="fas fa-pepper-hot" padding="0px">
                                    <!--
                                    <template v-slot:titlebar>
                                        <span @click="addToShoppingList = true" title="Add to shopping list" class="add-shopping pointer d-flex justify-content-end align-items-center">
                                            <i class="fas fa-plus plus"></i>
                                            <i class="fas fa-shopping-basket"></i>
                                        </span>
                                    </template>
                                    -->

                                    <div v-if="!addToShoppingList">
                                        <div v-for="(ingredient, index) in ingredients" v-bind:key="index">   
                                            <div v-if="index === 0" class="ingredient-padding"></div>

                                            <div class="ingredient normalFont letter-spacing d-flex justify-content-between">
                                                <div 
                                                    v-bind:class="{'matching_ingredient': ingredientExistsInSearch(ingredient)}">
                                                    <i v-if="ingredientExistsInSearch(ingredient)" class="fas fa-check mr-1"></i>
                                                    <span>{{ingredient.fooditem_name}}</span>
                                                </div>

                                                <div class="d-flex justify-content-end muted">
                                                    <span class="mr-2">{{ingredient.amount}}</span>
                                                    <div class="text-left ">{{ingredient.measurement_name}}</div>
                                                </div>
                                            </div>

                                            <hr v-if="index !== ingredients.length - 1">
                                            <div v-else class="ingredient-padding"></div>
                                        </div>

                                        <button title="Add ingredients to shopping list" class="btn btn-success w-100">
                                            <i class="fas fa-plus mr-2"></i>
                                            <span>Add ingredients to shopping list</span>
                                        </button>
                                    </div>

                                    <div v-else>
                                        
                                    </div>
                                </Window>
                            </div>
                        </div>

                        <div class="col-lg-7 col-md-6 px-0 pl-md-3 mb-3">
                            <div class="instructions-container">
                                <Placeholder v-if="!instructions" height="25px" v-bind:amount="6" v-bind:spacing="15"></Placeholder>
                                
                                <Window v-else title="Instructions" icon="fas fa-list-ol" padding="0px">
                                    <div v-for="(instruction, index) in instructionsSorted" v-bind:key="index">
                                        <div v-if="index === 0" class="ingredient-padding"></div>
                                        <div class="instruction normalFont letter-spacing d-flex justify-content-start">
                                            <div class="number muted">{{instruction.number}}.</div>
                                            <div>{{instruction.instruction}}</div>
                                        </div>

                                        <hr v-if="index !== instructions.length - 1">
                                        <div v-else class="ingredient-padding"></div>
                                    </div>
                                </Window>
                            </div>
                        </div>

                        <div class="col-12 px-0 mt-md-3 mt-0">
                            <Placeholder v-if="!reviews" height="50px" v-bind:amount="3" v-bind:spacing="15"></Placeholder>
                            <Window v-else title="Ratings" icon="fas fa-star" padding="0px">
                                <div class="container-fluid review-container">
                                    <div class="row">
                                        <div class="col-12 px-3 pt-3" v-if="isLoggedIn">
                                            <Rate @rated="rated" v-bind:max="5" v-bind:recipeId="id"></Rate>
                                        </div>

                                        <div class="col-12 px-3 pt-3 pb-1 d-flex justify-content-start align-items-center" v-else>
                                            <button @click="$store.commit('setShowLoginSidebar', true)" class="btn btn-outline-light mr-2"><i class="fas fa-sign-in-alt mr-2"></i>Login</button>
                                            <span>to leave a review</span>
                                        </div>

                                        <div class="col-md-12 px-3 normalFont letter-spacing text-left" v-if="reviews.length === 0">
                                            Be the first to review this recipe!
                                        </div>

                                        <div class="col-md-12 px-0" v-for="(review, index) in reviewsSorted" v-bind:key="index">
                                            <hr v-if="index === 0">

                                            <div class="review">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <Stars v-bind:stars="review.rating" max="5"></Stars>
                                                    </div>
                                                    <div class="normalFont muted letter-spacing date">{{timeFromEpoch(review.created_epoch)}}</div>
                                                </div>

                                                <div class="author">{{review.author}}</div>
                                                <div v-if="review.comment" class="normalFont letter-spacing mt-3">{{review.comment}}</div>
                                            </div>

                                            <hr v-if="index !== reviewsSorted.length - 1">
                                            <div v-else class="ingredient-padding"></div>
                                        </div>
                                    </div>
                                </div>
                            </Window>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>


<script>
    import Placeholder from  '../components/Placeholder.vue';
    import Stars from  '../components/Stars.vue';
    import Window from  '../components/Window.vue';
    import Rate from  '../components/Rate.vue';

    export default {
        name: 'Recipe',
        props: {
            id: Number
        },
        components: {Placeholder, Stars, Window, Rate},

        data() {
            return {
                recipeInfo: null,
                ingredients: null,
                instructions: null,
                reviews: null,
                comments: null,
                ingredientsSearch: JSON.parse(window.localStorage.getItem('recipes-ingredients')) || [],
                isBookmarked: false,
                addToShoppingList: false,
                showAddRating: false
            }
        },

        computed: {
            imgURL() {
                return `${process.env.VUE_APP_REST_ADDR}/api/files/img/${this.recipeInfo.file_id}.${this.recipeInfo.file_type.split('/')[1]}`;
            },

            instructionsSorted() {
                if(this.instructions) {
                    return this.instructions.sort((a, b) => {
                        return a.number - b.number;
                    });
                } else {
                    return null;
                }
            },

            reviewsSorted() {
                if(this.reviews) {
                    return this.reviews.sort((a, b) => {
                        return b.created_epoch - a.created_epoch;
                    });
                } else {
                    return null;
                }
            },

            isLoggedIn() {
                return this.$store.getters.token !== null;
            }
        },

        methods: {
            ingredientExistsInSearch(ingredient) {
                return this.ingredientsSearch.some(i =>  i.id === ingredient.fooditem_id);
            },

            getRecipeInfo() {
                this.$store.dispatch('getRecipe', {
                    id: this.id
                })
                .then((response) => {
                    this.recipeInfo = response;
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            getIngredients() {
                this.$store.dispatch('getRecipeIngredients', {
                    id: this.id
                })
                .then((response) => {
                    this.ingredients = response;
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            getInstructions() {
                this.$store.dispatch('getRecipeInstructions', {
                    id: this.id
                })
                .then((response) => {
                    this.instructions = response;
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            getReviews() {
                this.$store.dispatch('getRecipeRatings', {
                    id: this.id
                })
                .then((response) => {
                    this.reviews = response;
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            timeFromEpoch(epoch) {
				let date = new Date(epoch * 1000);

				return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()}`;
            },
            
            rated() {
                this.getRecipeInfo();
                this.getReviews();
            },

            addToFavorites() {
                this.$store.dispatch('bookmark', {
                    id: parseInt(this.id)
                })
                .then((response) => {
                    this.$store.commit('setSystemMessage', {
                        content: `Recipe ${response ? 'added to' : 'removed from'} favorites.`,
                        error: false
                    });

                    this.getRecipeInfo();
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            addToPlan() {
                if(this.isLoggedIn) {

                } else {
                    this.$store.commit('setShowLoginSidebar', true);
                }
            }
        },

        activated() {
            
        },

        mounted() {
            this.getRecipeInfo();
            this.getIngredients();
            this.getInstructions();
            this.getReviews();
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .recipe {
        margin-top: 48px;
        color: @main-background;
        background-color: rgba(227, 234, 235, 0.63);
        min-height: 100vh;
    }

    .recipe-container {
        width: 100%;
        max-width: @main-content-width;
    }

    .details {
        position: relative;
        background-color: white;
        box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
    }

    .action-buttons {
        position: absolute;
        right: 0px;
        bottom: 0px;
    }

    img {
        height: 320px;
        width: 100%;
		object-fit: cover;
    }

    .title {
        font-size: 18pt;
    }

    .description {
        font-size: 12pt;
        font-style: italic;
        margin-bottom: 24px;
    }

    .letter-spacing  {
        letter-spacing: 0.01rem;
    }

    .amount {
        min-width: 30px;
        margin-right: 10px;
    }

    .measurement {
        min-width: 50px;
        //font-style: italic;
        padding-left: 8px;
    }

    tr.spaceUnder>td {
        padding-bottom: 5px;
    }

    .spaceRight {
        padding-right: 20px;
    }

    .number-of-ratings {
        font-size: 11pt;
        margin-bottom: -2px;
    }

    .btn-outline-light {
		border-color: @main-background;
        color: @main-background;
        background-color: @main-color;
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

    .author {
        font-size: 11pt;
        //opacity: 0.8;
    }


    .date {
        font-size: 10pt;
    }

    textarea  {
        border-color: @main-background;
    }

    textarea:focus  {
        border-color: @main-background !important;
    }

    .profile-icon {
        font-size: 32pt;
    }

    .dots {
        flex: 1;
        overflow: hidden;
        opacity: 0.3;
    }

    .my-rating {
        color: rgb(46, 136, 46);
    }

    .ingredient, .instruction, .review {
        padding: 0px 16px;
    }

    .ingredients-container, .instructions-container, .review-container {
        hr {
            opacity: 0.15;
            margin-top: 12px;
            margin-bottom: 12px;
        }
    }

    .ingredient-padding {
        height: 16px;
    }

    .matching_ingredient {
        font-weight: 600;
    }

    .rated-by {
        font-size: 10pt;
    }

    .banner {
        background-color: @main-background;
        height: 40px;
    }

    .add-shopping  {
        opacity: 0.8;

        .plus {
            font-size: 8pt;
            margin-right: 3px;
        }
    }

    .add-shopping:hover {
        opacity: 1;
    }

    .number {
        min-width: 30px;
        //margin-right: 10px;
        //text-align: right;
    }
</style>