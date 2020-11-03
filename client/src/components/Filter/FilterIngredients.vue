<template>
    <div class="filteringredients">
        <div class="font-l mb-1">
            <span>Search by ingredients</span>
        </div>

        <DropdownSelector
            :displayValue="'name'"
            :searchAction="'fooditemsQuery'"
            :searchValue="'search'"
            :placeholder="'Add ingredient'"
            :border="true"
            @selected="ingredientSelected"/>
        
        <div class="flex-start-start flex-wrap pt-2">
            <div
                class="card-main font-m px-2 py-1 mb-2 mr-2 cursor-pointer"
                v-for="(ingredient, index) in $store.getters.ingredients" 
                :key="index"
                @click="remove(ingredient)">   
                
                {{ingredient.name}}
                <i title="Remove" class="fas fa-times-circle ml-1"></i>
            </div>
        </div>
    </div>
</template>

<script>
    import { nextTick } from 'vue';
    import DropdownSelector from '../DropdownSelector.vue';

    export default {
        name: 'filteringredients',

        components: {
            DropdownSelector
        },

        methods: {
            ingredientSelected(ingredient) {
                this.$store.commit('addIngredient', ingredient);
            },

            remove(ingredient) {
                this.$store.commit('removeIngredient', ingredient);
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";

    .selected {
        border: 1px solid @main-color;
    }
</style>