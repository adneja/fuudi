<template>
    <div class="recipeingredients card-inverted p-3" v-if="ingredients">
        <!--<Window title="Ingredients" icon="fas fa-pepper-hot">-->
            <div v-if="!showEditIngredients">
                <button class="btn btn-outline-primary w-100 mb-md-4 mb-3" @click="showEditIngredients = true">
                    <i class="fas fa-plus mr-2"></i>
                    <span>Add to shopping list</span>
                </button>
        
                <div class="font-normal flex-between-center mb-1" v-for="(ingredient, index) in ingredients" :key="index">
                    <div>
                        <span v-if="$store.getters.ingredients.length > 0">
                            <i v-if="ingredientMatch(ingredient)" class="fas fa-check mr-1"></i>
                        </span>
                        <span>{{ingredient.fooditem_name}}</span>
                    </div>
                    <div class="font-faded">
                        <span class="mr-1">{{ingredient.amount}}</span>
                        <span>{{ingredient.measurement_name}}</span>
                    </div>
                </div>
            </div>

            <!-- Edit shopping list -->
            <div v-else>
                <div class="flex-between-start mb-md-4 mb-3">
                    <button class="btn btn-outline-primary w-100 mr-1" @click="cancel">
                        <i class="fas fa-times"></i>
                        <span class="d-md-inline d-none ml-2">Cancel</span> 
                    </button>

                    <button class="btn btn-outline-primary w-100 ml-1" @click="addToShoppinglist">
                        <i class="fas fa-check"></i>
                        <span class="d-md-inline d-none ml-2">Add</span> 
                    </button>
                </div>

                <div class="flex-between-center mb-1" v-for="(ingredient, index) in ingredients" :key="index">
                    <div class="flex-start-center">
                        <Checkbox 
                            :initialStatus="ingredient.checked"
                            @changed="status => ingredient.checked = status"/>
                        <span class="font-normal">{{ingredient.fooditem_name}}</span>
                    </div>

                    <div class="flex-end-center font-normal">
                        <input class="amount form-control input-border" type="number" min="0" v-model="ingredient.amount">
                        <span class="measurement ml-1">{{ingredient.measurement_name}}</span>
                    </div>
                </div>
            </div>
        <!--</Window>-->
    </div>
</template>

<script>
    import Placeholder from '../Placeholder.vue';
    import Checkbox from '../Checkbox.vue';
    import Window from '../Window.vue';

    export default {
        name:'recipeingredients',

        props: {
            id: Number
        },

        components: {
            Placeholder,
            Checkbox,
            Window
        },

        data() {
            return {
                ingredients: null,
                showEditIngredients: false
            }
        },

        computed: {
            selectedIngredients() {
                return this.ingredients.filter(i => i.checked);
            }
        },

        methods: {
            getIngredients() {
                this.$store.dispatch('recipesIngredientsGet', {
                    id: this.id
                })
                .then((response) => {
                    this.ingredients = response.map((i) => {
                        return {...i, checked: !this.ingredientMatch(i)};
                    });
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            ingredientMatch(ingredient) {
                return this.$store.getters.ingredients.some(i => i.id == ingredient.fooditem_id);
            },

            addToShoppinglist() {
                let shoppinglist = this.selectedIngredients.map((ingredient) => {
                    return {
                        fooditem_id: ingredient.fooditem_id,
                        measurement_id: ingredient.measurement_id,
                        amount: ingredient.amount
                    }
                });

                this.$store.dispatch('usersShoppinglistInsertBulk', {
                    shoppinglist: shoppinglist
                })
                .then((response) => {
                    this.$store.commit('setShoppingList', response);

                    this.$store.commit('setSystemMessage', {
                        content: `${shoppinglist.length} items have been added to your shoppinglist`,
                        error: false
                    });

                    this.cancel();
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },

            cancel() {
                this.showEditIngredients = false;
                this.getIngredients();
            }
        },

        mounted() {
            this.getIngredients();
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";

    .measurement {
        width: 45px;
    }

    .amount {
        width: 70px;
    }
</style>