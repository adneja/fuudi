<template>
    <!--<Window title="Ingredients" icon="fas fa-pepper-hot">-->
        <div>
           <div class="font-l mb-1 font-primary">Ingredients</div>
           
            <div class="flex-start-center customshadow">
                <DropdownSelector 
                    :searchAction="'fooditemsQuery'" 
                    :displayValue="'name'"
                    :searchValue="'search'"
                    :placeholder="'Search'"
                    :border="false"
                    @selected="itemSelected"
                    @create="createFooditem"
                    :entityName="'ingredient'"
                    :showCreate="true"
                    class="w-100"/>

                <button class="btn btn-secondary"><i class="fas fa-search"></i></button>
            </div>
            
            <div class="mt-2 card-inverted flex-start-center" v-for="(ingredient, index) in ingredients" :key="index">
                <div class="container-fluid w-100">
                    <div class="row">
                        <div class="col-md-8 px-0 pb-md-0 flex-between-center">
                            <div class="name font-display font-m">{{ingredient.name}}</div>
                            
                            <button @click="remove(index)" class="d-md-none d-block btn btn-secondary">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>

                        <div class="col-12 px-0 d-md-none d-block">
                            <div class="mobile-border"></div>
                        </div>

                        <div class="col-md-2 col-6 px-md-0 flex-start-center">
                            <span class="font-s font-faded">Amount:</span>
                            <input v-model="ingredient.amount" type="number" min="0" class="form-control" placeholder="---">
                        </div>

                        <div class="col-md-2 col-6 px-0 flex-start-center">
                            <span class="font-s font-faded">Unit:</span>

                            <DropdownSelector 
                                :searchAction="'measurementsQuery'" 
                                :displayValue="'name'"
                                :searchValue="'search'"
                                :placeholder="'---'"
                                :border="false"
                                :showSelected="true"
                                :small="false"
                                :entityName="'unit'"
                                class="font-m"
                                @selected="unitSelected($event, index)"/>
                        </div>
                    </div>
                </div>

                <button @click="remove(index)" class="d-md-block d-none btn btn-primary">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    <!--</Window>-->
</template>

<script>
    import Window from '../Window.vue';
    import DropdownSelector from '../DropdownSelector.vue';

    export default {
        name: 'recipecreatoringredients',

        components:  {
            Window,
            DropdownSelector
        },

        data() {
            return {
                ingredients: []
            }
        },

        methods: {
            itemSelected(fooditem) {
                this.ingredients.push({...fooditem, amount: null, unit: null});
            },

            unitSelected(measurement, index) {
                this.ingredients[index].unit = measurement;
            },

            updateIngredient(fooditem, index) {
                this.ingredients[index] = {...fooditem, amount: null, unit: null};
            },

            remove(index) {
                this.ingredients.splice(index, 1);
            },

            createFooditem(name) {
                this.$store.dispatch('fooditemsInsert', {
                    name: name
                })
                .then((response) => {
                    this.ingredients.push({...response[0], amount: null, unit: null});

                    this.$store.commit('setSystemMessage', {
                        content: `${response[0].name} has been added to the database`,
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
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";

    .name {
        padding: 6px 15px;
    }

    .mobile-border {
        height: 1px;
        background-color: @main-background;
        opacity: 0.15;
    }
</style>