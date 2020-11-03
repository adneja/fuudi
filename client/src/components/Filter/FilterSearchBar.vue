<template>
    <div class="filtersearchbar">
        <div class="input-group customshadow">
            <button title="Show favorites" class="btn btn-primary" @click="showFavorites = !showFavorites">
                <i v-if="!$store.getters.showFavorites" class="far fa-heart"></i>
                <i v-else class="fas fa-heart"></i>
            </button>

            <input 
                class="form-control" 
                type="text" 
                placeholder="Search recipes" 
                v-model="searchWord">

            <button v-if="$store.getters.searching" title="Searching.." class="btn btn-secondary">
                <i class="fas fa-circle-notch fa-spin"></i>
            </button>

            <button 
                v-if="searchWord.trim().length > 0 && !$store.getters.searching" 
                title="Clear" 
                class="btn btn-secondary cursor-pointer"
                @click="searchWord = ''">
                
                <i class="fas fa-times"></i>
            </button>

            <button title="Show filters" class="btn btn-primary" @click="$emit('toggle-filter')">
                <i class="fas fa-filter"></i>
                <span v-if="$store.getters.numAppliedFilters > 0" class="font-m font-faded ml-1">({{$store.getters.numAppliedFilters}})</span>
            </button>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'filtersearchbar',

        data() {
            return {
                searchWord: this.$store.getters.searchWord,
                showFavorites: this.$store.getters.showFavorites
            }
        },

        watch: {
            searchWord() {
                this.$store.commit('setSearchWord', this.searchWord);
            },

            showFavorites() {
                this.$store.commit('setShowFavorites', this.showFavorites);
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";
</style>