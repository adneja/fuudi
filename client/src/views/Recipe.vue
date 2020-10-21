<template>
    <div class="recipe">
        <div class="details d-flex justify-content-center">
            <div class="recipe-container px-md-5">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-6 p-0">
                            <Placeholder v-if="!recipeInfo" height="350px" v-bind:amount="1" v-bind:spacing="0"></Placeholder>
                            <img v-else v-bind:src="imgURL" width="100%">
                        </div>

                        <div class="col-md-6 p-md-4 p-3">
                            <div v-if="!recipeInfo">
                                <Placeholder height="50px" v-bind:amount="1" v-bind:spacing="30"></Placeholder>
                                <Placeholder height="20px" v-bind:amount="4" v-bind:spacing="10"></Placeholder>
                            </div>

                            <div v-else>
                                <div class="title">{{recipeInfo.name}}</div>
                                <span class="d-flex justify-content-start align-items-center mb-3">
                                    <Stars v-bind:stars="recipeInfo.rating" max="5"></Stars>
                                    <span class="number-of-ratings muted ml-2">({{recipeInfo.number_of_ratings}})</span>
                                </span>
                                <div class="mb-3 author">by {{recipeInfo.created_by}}</div>
                                <div class="normalFont description letter-spacing ">{{recipeInfo.description}}</div>
                            </div>

                            <div class="col-12 px-0 pt-3">
                                <button class="btn btn-outline-light mr-2 mb-2"><i class="far fa-heart mr-1"></i>Save to favorites</button>
                                <button class="btn btn-outline-light mr-2 mb-2"><i class="far fa-calendar-check mr-1"></i>Add to meal plan</button>
                                <button class="btn btn-outline-light mb-2"><i class="fas fa-shopping-basket mr-1"></i>Add to shopping list</button>
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
                        <div class="col-md-4 px-0 pr-md-3 mb-3">
                            <div class="ingredients-container">
                                <Placeholder v-if="!ingredients" height="25px" v-bind:amount="8" v-bind:spacing="15"></Placeholder>
                                <Window title="Ingredients" icon="fas fa-pepper-hot">
                                    <table class="normalFont letter-spacing">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th></th>
                                                <th></th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <tr class="spaceUnder " v-for="(ingredient, index) in ingredients" v-bind:key="index">
                                                <td class="spaceRight">{{ingredient.fooditem_name}}</td>
                                                <td align="right" class="">{{ingredient.amount}}</td>
                                                <td class="measurement">{{ingredient.measurement_name}}</td>
                                            </tr>  
                                        </tbody>
                                    </table>
                                </Window>
                            </div>
                        </div>

                        <div class="col-md-8 px-0 pl-md-3">
                            <div class="instructions-container">
                                <Placeholder v-if="!instructions" height="25px" v-bind:amount="6" v-bind:spacing="15"></Placeholder>
                                <Window title="Instructions" icon="fas fa-list-ol">
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

                        <div class="col-12 px-0 mt-3">
                            <Window title="Reviews" icon="fas fa-comment">
                                
                            </Window>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-center">
            <div class="recipe-container px-md-5 py-md-4 px-3 py-3">
                <div class="container-fluid">
                    <div class="row">

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

    export default {
        name: 'Recipe',
        props: {
            id: Number
        },
        components: {Placeholder, Stars, Window},

        data() {
            return {
                recipeInfo: null,
                ingredients: null,
                instructions: null,
                reviews: null,
                comments: null,
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
            }
        },

        methods: {
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

            },
        },

        activated() {
            
        },

        mounted() {
            this.getRecipeInfo();
            this.getIngredients();
            this.getInstructions();
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
        height: 350px;
        width: 100%;
		object-fit: cover;
    }

    .title {
        font-size: 16pt;
    }

    .description {
        font-size: 13pt;
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
        font-style: italic;
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
        font-size: 12pt;
    }
</style>