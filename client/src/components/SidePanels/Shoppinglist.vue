<template>
    <div class="shoppinglist">
        <transition name="slide-in-right">
            <SidePanel 
                title="Shoppinglist"
                icon="fas fa-shopping-basket"
                colors="main"
                location="right"
                width="450px"
                @close="closeShoppingList"
                v-if="$store.getters.showShoppingList">

                <div 
                    v-for="(item, index) in $store.getters.shoppingList" 
                    :key="index" 
                    class="mb-2 font-l font-normal flex-between-center cursor-pointer">

                    <div class="flex-start-center">
                        <Checkbox :status="item.checked" @change="status => item.checked = status"/>
                        <span>{{item.fooditem_name}}</span>
                    </div>

                    <div>
                        <span>{{formatAmount(item.standardized_measurement, item.amount)}}</span>
                    </div>
                </div>

                <template v-slot:footer>
                    <button class="btn btn-secondary w-100">Clear</button>
                </template>
            </SidePanel>
        </transition>
    </div>
</template>

<script>
    import SidePanel from './SidePanel.vue';
    import Checkbox from '../Checkbox.vue';
    
    export default {
        name: 'shoppinglist',

        components: {
            SidePanel,
            Checkbox
        },

        methods: {
            closeShoppingList() {
                this.$store.commit('setShowShoppingList', false);
            },

            formatAmount(measurement, amount) {
                if(measurement === 'ml') {
                    let dl = amount / 100,
                        l = dl / 10;
                    
                    if(l > 1) return l + ' l';
                    return dl >= 1 ? dl + ' dl' : amount + ' ml';
                } else if(measurement === 'g') {
                    let kg = amount / 1000;
                    return kg >= 1 ? kg + ' kg' : amount + ' g'
                } else {
                    return amount + ' ' + measurement;
                }
            }
        },

        mounted() {
            this.$store.dispatch('usersShoppinglistGet')
            .then((response) => {
                this.$store.commit('setShoppingList', response);
            })
            .catch((err) => {
                console.log(err);
            });
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";
</style>