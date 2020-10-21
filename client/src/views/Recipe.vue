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
                                <div class="author d-flex justify-content-start align-items-center mb-3">
                                    <i class="far fa-user-circle mr-1 profile-icon mr-2"></i>
                                    <div>
                                        <div>By {{recipeInfo.created_by}}</div>
                                        <div class="normalFont date letter-spacing">{{timeFromEpoch(recipeInfo.created_epoch)}}</div>
                                    </div>
                                </div>
                               
                               <div class="title">{{recipeInfo.name}}</div>
                               <span class="d-flex justify-content-start align-items-center mb-2">
                                    <Stars v-bind:stars="recipeInfo.rating" max="5"></Stars>
                                    <span class="number-of-ratings muted ml-2">({{recipeInfo.number_of_ratings}})</span>
                                </span>
                               
                                <div class="normalFont description letter-spacing">{{recipeInfo.description}}</div>
                            
                                <div class="pt-3">
                                    <button 
                                        class="btn btn-outline-light mr-2 mb-2"
                                        @click="addToFavorites">
                                        <i class="far fa-heart mr-1"></i>
                                        <span>Add to favorites</span>
                                    </button>

                                    <button 
                                        class="btn btn-outline-light mr-2 mb-2"
                                        @click="addToPlan">
                                        <i class="far fa-calendar-check mr-1"></i>
                                        <span>Add to meal plan</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-center">
            <div class="recipe-container px-md-5 py-md-4 px-0 py-0">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-5 col-md-6 px-0 pr-md-3 mb-md-3 mb-0">
                            <div class="ingredients-container">
                                <Placeholder v-if="!ingredients" height="25px" v-bind:amount="8" v-bind:spacing="15"></Placeholder>
                                <Window v-else title="Ingredients" icon="fas fa-pepper-hot">
                                    <div 
                                        class="d-flex align-items-end normalFont letter-spacing mb-2"
                                        v-for="(ingredient, index) in ingredients" v-bind:key="index">

                                        <div v-bind:class="{'matching_ingredient': ingredientExistsInSearch(ingredient)}">{{ingredient.fooditem_name}}</div>
                                        <span class="dots">......................................................................</span>
                                        <div class="d-flex justify-content-end muted">
                                            <span>{{ingredient.amount}}</span>
                                            <div class="text-left measurement">{{ingredient.measurement_name}}</div>
                                        </div>
                                    </div>

                                    <div class="mt-4">
                                        <button class="btn btn-outline-light"><i class="fas fa-shopping-basket mr-2"></i>Add to shopping list</button>
                                    </div>
                                </Window>
                            </div>
                        </div>

                        <div class="col-lg-7 col-md-6 px-0 pl-md-3">
                            <div class="instructions-container">
                                <Placeholder v-if="!instructions" height="25px" v-bind:amount="6" v-bind:spacing="15"></Placeholder>
                                <Window v-else title="Instructions" icon="fas fa-list-ol">
                                    <table class="normalFont letter-spacing">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th></th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <tr class="spaceUnder" v-for="(instruction, index) in instructionsSorted" v-bind:key="index">
                                                <td align="right" valign="top" class="spaceRight font-weight-bold">{{instruction.number}}.</td>
                                                <td>{{instruction.instruction}}</td>
                                            </tr>  
                                        </tbody>
                                    </table>
                                </Window>
                            </div>
                        </div>

                        <div class="col-12 px-0 mt-md-3 mt-0">
                            <Placeholder v-if="!reviews" height="50px" v-bind:amount="3" v-bind:spacing="15"></Placeholder>
                            <Window v-else title="Reviews" icon="fas fa-comment">
                                <div class="container-fluid">
                                    <div class="row">
                                        <div class="col-12 px-0 mb-4" v-if="isLoggedIn">
                                            <Rate @rated="rated" v-bind:max="5" v-bind:recipeId="id"></Rate>
                                        </div>

                                        <div class="col-12 px-0 mb-4 d-flex justify-content-start align-items-center" v-else>
                                            <button @click="$store.commit('setShowLoginSidebar', true)" class="btn btn-outline-light mr-2"><i class="fas fa-sign-in-alt mr-2"></i>Login</button>
                                            <span>to leave a review</span>
                                        </div>

                                        <div class="col-md-12 px-0 normalFont letter-spacing text-left" v-if="reviews.length === 0">
                                            Be the first to review this recipe!
                                        </div>

                                        <div class="col-md-12 px-0" v-for="(review, index) in reviews" v-bind:key="index">
                                            <div class="review">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div class="author">
                                                        <span>{{review.author}}</span>
                                                        <span class="ml-2 my-rating" v-if="review.my_rating">(you)</span>
                                                    </div>
                                                    <div class="normalFont letter-spacing date">{{timeFromEpoch(review.created_epoch)}}</div>
                                                </div>
                                                
                                                <Stars class="mb-3" v-bind:stars="review.rating" max="5"></Stars>
                                                <div class="normalFont letter-spacing">{{review.comment}}</div>
                                            </div>
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
                ingredientsSearch: JSON.parse(window.localStorage.getItem('recipes-ingredients')) || []
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
                if(this.isLoggedIn) {

                } else {
                    this.$store.commit('setShowLoginSidebar', true);
                }
            },

            addToPlan() {
                if(this.isLoggedIn) {

                } else {
                    this.$store.commit('setShowLoginSidebar', true);
                }
            },

            favorite() {
				this.$store.dispatch('bookmark', {
					id: parseInt(this.id)
				})
				.then((response) => {
					this.showFavorite = response;
					this.$store.commit('setSystemMessage', {
						content: `Recipe ${response ? 'added to' : 'removed from'} favorites.`,
						error: false
					});
				})
				.catch((err) => {
					this.$store.commit('setSystemMessage', {
						content: err,
						error: true
					});
				});
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
        background-color: white;
        box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
    }

    img {
        height: 320px;
        width: 100%;
		object-fit: cover;
    }

    .title {
        font-size: 16pt;
    }

    .description {
        font-size: 13pt;
        font-style: italic;
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
    }

    .review {
        //box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
        //padding: 10px;
        padding-bottom: 10px;
        padding-top: 10px;
        border-top: 1px solid @main-background;
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

    .matching_ingredient {
        font-weight: 600;
    }
</style>