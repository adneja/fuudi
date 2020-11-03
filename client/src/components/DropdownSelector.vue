<template>
    <div class="dropdownselector">
        <div class="relative">
            <input 
                ref="search"
                class="form-control" 
                :class="{'input-border': border, 'form-control-sm': small}"
                type="text" 
                :placeholder="placeholder"
                v-model="searchWord"
                @keydown.stop.prevent.down="marked++"
                @keydown.stop.prevent.up="marked--"
                @keydown.enter="selectMarked"
                @keydown.escape="clearSearchResults"
                @blur="onBlur">
            
            <transition name="fade-in">
                <div v-if="searchResults.length > 0" class="absolute-top-left w-100 card-inverted results-dropdown customshadow">
                    <div 
                        class="font-m px-3 py-2 search-result cursor-pointer" 
                        v-for="(result, index) in searchResults" 
                        :key="index"
                        @click="select(result)"
                        :class="[index === marked ? 'colors-main' : '']"
                        @mouseenter="marked = index">

                        {{result[displayValue]}}
                    </div>
                </div>
            </transition>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'dropdownselector',

        props: {
            searchAction: String,
            displayValue: String,
            searchValue: String,
            placeholder: String,
            border: Boolean,
            showSelected: Boolean,
            small: Boolean,
            startSelected: Object
        },

        data() {
            return {
                searchWord: '',
                searchDelay: null,
                searchResults: [],
                marked: 0,
                selected: this.startSelected
            }
        },

        methods: {
            search() {
                this.$store.dispatch(this.searchAction, {
                    [this.searchValue]: this.searchWord
                })
                .then((response) => {
                    this.searchResults = response;
                })
                .catch((err) => {
                    console.log(err);
                });
            },

            select(result) {
                this.selected = result;
                this.$emit('selected', result);
                this.clearSearchResults();
            },

            selectMarked() {
                this.selected = this.searchResults[this.marked];
                this.$emit('selected', this.searchResults[this.marked]);
                this.clearSearchResults();
            },

            clearSearchResults() {
                this.searchWord = this.showSelected ? this.selected[this.displayValue] : '';
                this.searchResults = [];
                this.marked = 0;
            },

            onBlur() {
                if(!this.selected) {
                    if(this.searchResults.length > 0) {
                        this.selected = this.searchResults[0];
                        this.searchResults = [];
                    } else {
                        this.searchWord = '';
                        this.searchResults = [];
                        this.marked = 0;
                    }
                }
            }
        },

        watch: {
            searchWord() {
                if(this.searchDelay) {
                    clearTimeout(this.searchDelay);
                    this.searchDelay = null;
                }

                if(this.selected) {
                    if(this.showSelected && (this.searchWord === this.selected[this.displayValue])) {
                        this.searchResults = [];
                        return;

                    }
                }

                this.searchDelay = setTimeout(() => {
                    if(this.searchWord.trim().length > 0) {
                        this.search();
                    } else {
                        this.searchResults = [];
                    }
                }, 400);
            },

            marked() {
                if(this.marked > this.searchResults.length - 1) {
                    this.marked = 0;
                } else if (this.marked < 0) {
                    this.marked = this.searchResults.length - 1;
                }
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/styles/custom.less";

    .results-dropdown {
        top: 42px;
        z-index: 999;
    }

    .selected {
        padding: 6px 12px;
    }
</style>