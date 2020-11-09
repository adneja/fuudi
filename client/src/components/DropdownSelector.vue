<template>
    <div class="dropdownselector">
        <div class="relative">
            <div class="input-group">
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

                <button v-if="searching" class="btn btn-secondary">
                    <i class="fas fa-circle-notch fa-spin"></i>
                </button>
            </div>
            
            <transition name="fade-in">
                <div v-if="searchResultsWithCreateOption.length > 0" class="absolute-top-left w-100 card-inverted results-dropdown customshadow">
                    <div 
                        class="font-m px-3 py-2 search-result cursor-pointer" 
                        v-for="(result, index) in searchResultsWithCreateOption" 
                        :key="index"
                        @click="select(result)"
                        :class="[index === marked ? 'colors-main' : '']"
                        @mouseenter="marked = index">

                        <span v-if="result.createNew">
                            <i class="fas fa-plus-circle mr-1"></i>
                        </span>
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
            startSelected: Object,
            showCreate: Boolean
        },

        data() {
            return {
                searchWord: '',
                searchDelay: null,
                searchResults: [],
                searching: false,
                marked: 0,
                selected: this.startSelected
            }
        },

        computed: {
            showCreateItem() {
                if(!this.showCreate) {
                    return false;
                }

                let exists = this.searchResults.filter((i) => {
                    return i.name.toLowerCase() === this.searchWord.toLowerCase();
                }).length !== 0;

                return !exists;
            },

            searchResultsWithCreateOption() {
                let returnArray = this.searchResults;

                let exists = this.searchResults.filter((i) => {
                    return i.name.toLowerCase() === this.searchWord.toLowerCase();
                }).length !== 0;

                if(this.searchWord.trim().length > 0 && !exists && !this.searching && this.showCreate) {
                    returnArray.push({
                        id: -1,
                        [this.displayValue]: this.searchWord,
                        createNew: true
                    });
                }

                return returnArray;
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
                })
                .finally(() => {
                    this.searching = false;
                });
            },

            select(result) {
                if(this.searchResultsWithCreateOption.length > 0) {
                    this.selected = result;

                    if(this.selected.createNew) {
                        this.$emit('create', this.selected[this.displayValue]);
                    } else {
                        this.$emit('selected', this.selected);
                    }
                    
                    this.clearSearchResults();
                }
            },

            selectMarked() {
                if(this.searchResultsWithCreateOption.length > 0) {
                    this.selected = this.searchResults[this.marked];

                    if(this.selected.createNew) {
                        this.$emit('create', this.selected[this.displayValue]);
                    } else {
                        this.$emit('selected', this.selected);
                    }
                    
                    this.clearSearchResults();
                }
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

                this.searching = true;

                this.searchDelay = setTimeout(() => {
                    if(this.searchWord.trim().length > 0) {
                        this.search();
                    } else {
                        this.searching = false;
                        this.searchResults = [];
                    }
                }, 400);
            },

            marked() {
                if(this.marked > this.searchResultsWithCreateOption.length - 1) {
                    this.marked = 0;
                } else if (this.marked < 0) {
                    this.marked = this.searchResultsWithCreateOption.length - 1;
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