<template>
    <div class="filtermain">
        <FilterSearchBar @toggle-filter="showFilters = !showFilters"/>

        <transition name="slide-in-left">
            <SidePanel
                v-show="showFilters" 
                title="Filters" 
                icon="fas fa-filter" 
                width="450px"
                location="left" 
                colors="inverted"
                @close="showFilters = false">

                <FilterIngredients class="mb-4"/>
                <FilterCookingTime :min="1" :max="120"/>

                <template v-slot:footer>
                    <button class="btn btn-primary w-100" @click="clearAll">
                        <span>Clear all</span>
                        <span v-if="$store.getters.numAppliedFilters" class="font-faded ml-2">({{$store.getters.numAppliedFilters}})</span>
                    </button>
                </template>
            </SidePanel>
        </transition>
    </div>
</template>

<script>
    import FilterSearchBar from './FilterSearchBar.vue';
    import FilterIngredients from './FilterIngredients.vue';
    import FilterCookingTime from './FilterCookingTime.vue';
    import FilterTags from './FilterTags.vue';
    import SidePanel from '../SidePanels/SidePanel.vue';

    export default {
        name: 'filtermain',

        props: {
            searchAction: String
        },

        components: {
            FilterSearchBar,
            FilterIngredients,
            FilterCookingTime,
            FilterTags,
            SidePanel
        },

        data() {
            return {
                showFilters: false,
                searchDelay: null
            }
        },

        computed: {
            searchParametersStringified() {
                return JSON.stringify({
                    search: this.$store.getters.searchWord,
                    ingredients: this.$store.getters.ingredients,
                    cookingTime: this.$store.getters.cookingTime
                });
            }
        },

        methods: {
            search() {
                this.$store.dispatch('recipesQuery', {
                    search: this.$store.getters.searchWord,
                    ingredients: JSON.stringify(this.$store.getters.ingredients.map((i) => i.id)),
                    cookingTime: this.$store.getters.cookingTime
                })
                .then((response) => {   
                    this.$emit('updated', response);
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                })
                .finally(() => {
                    this.$store.commit('setSearching', false);
                });
            },

            clearAll() {
                this.$store.dispatch('clearFilters');
                this.showFilters = false;
            }
        },

        watch: {
            searchParametersStringified() {
                if(this.searchDelay) {
                    clearTimeout(this.searchDelay);
                    this.searchDelay = null;
                }

                this.$store.commit('setSearching', true);
                this.searchDelay = setTimeout(() => {
                    this.search();
                }, 700);
            }
        },

        mounted() {
            this.search();
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";
</style>