<template>
    <div class="searchfield">
        <input  
            ref="input"
            class="form-control form-control-sm"
            v-model="searchWord" 
            v-on:keydown.right.stop.prevent="moveMarkedItem(true)"
            v-on:keydown.left.stop.prevent="moveMarkedItem(false)"
            v-on:blur="getMarkedItem"
            v-on:keyup.enter="getMarkedItem"
            v-on:keyup.esc="clear"
            v-bind:placeholder="placeholder"
            v-bind:class="[showResults ? 'borderShowResults' : '']">
        
        <div class="searching" v-if="searching && searchWord.trim().length > 0">
            <i class="text-dark fas fa-circle-notch fa-spin"></i>
        </div>
        
        <transition name="fade">
            <div 
                class="resultsContainer" 
                v-if="showResults"
                v-bind:class="[bottomPadding ? 'mb-2' : '']">

                <ItemSelector
                    ref='itemselection'
                    v-bind:items="items"
                    v-bind:target="enableCreatePrompt ? searchWord : null"
                    v-on:item-clicked="itemClicked">
                </ItemSelector>
            </div>
        </transition>
    </div>
</template>


<script>
    import ItemSelector from './ItemSelector.vue';

    export default {
        name: 'SearchField',
        props: [
            'action', 
            'displayField', 
            'placeholder', 
            'prompt', 
            'startValue', 
            'enableCreatePrompt', 
            'bottomPadding'
        ],

        components: {
            ItemSelector
        },

        data() {
            return {
                searchWord: this.startValue || '',
                searchResults: [],
                searching: false,
                showResults: false,

                items: [],
                selectedItem: null,

                currentTimeout: null
            }
        },

        methods: {
            search(searchWord) {
                if(this.searchWord.trim().length > 0) {
                    this.$store.dispatch(this.action, {
                        search: searchWord
                    })
                    .then((response) => {
                        this.items = response.map((item) => item[this.displayField]);

                        this.searchResults = {};
                        response.forEach((row) => {
                            this.searchResults[row[this.displayField]] = row;
                        });

                        this.showResults = true;
                    })
                    .catch((err) => {
                        console.log(err);
                    })
                    .finally(() => {
                        this.searching = false;
                    });
                } else {    
                    this.items = [];
                    this.searchResults = [];
                    this.searching = false;
                }
            },

            moveMarkedItem(right) {
                if(right) {
                    this.$refs.itemselection.markItemRight();
                } else {
                    this.$refs.itemselection.markItemLeft();
                }
            },

            getMarkedItem() {
                if(this.searchWord.trim().length > 0 && !this.searching) {
                    if(this.$refs.itemselection) {
                        let selectedItem = this.$refs.itemselection.markedItem;

                        if(selectedItem) {
                            this.$emit('item-selected', this.searchResults[selectedItem]);
                            this.selectedItem = selectedItem;
                            this.searchWord = selectedItem;
                        } else {
                            let newName = this.capitalize(this.searchWord)
                            this.$emit('create-item', newName);
                            this.selectedItem = newName;
                            this.searchWord = newName;
                        }

                        this.showResults = false;
                        this.searchResults = {};
                        this.items = [];
                    }
                }
            },

            itemClicked(item) {
                this.$emit('item-selected', this.searchResults[item]);
                this.showResults = false;
                this.selectedItem = item;
                this.searchWord = item;
                this.searchResults = {};
                this.items = [];
            },

            focus() {
                this.$refs.input.focus();
            },

            clear() {
                this.searchWord = '';
                this.selectedItem = null;
                this.searchResults = [];
                this.items = [];
                this.currentTimeout = null;
                this.searching = false;
                this.showResults = false;
            },

            capitalize(s) {
				let text = '';

				s.split(' ').forEach((word) => {
					text += word.charAt(0).toUpperCase() + word.slice(1).toLowerCase() + ' ';
				});

				return text.trim();
			}
        },

        watch: {
            searchWord() {
                clearTimeout(this.currentTimeout);
                
                if(this.selectedItem !== this.searchWord) {
                    if(this.searchWord.trim().length > 0) {
                        this.searching = true;
                        this.showResults = true;
                    } else {
                        this.showResults = false;
                        this.searching = false;
                    }
                    
                    this.currentTimeout = setTimeout(() => {
                        this.search(this.searchWord);
                    }, 500);
                } else {
                    this.searching = false;
                }
            }
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .searchfield {
        position: relative;
    }

    .searching {
        position: absolute;
        top: 4px;
        right: 4px;
    }

    .resultsContainer {
        position: absolute;
        top: 26px;
        left: 0px;
        z-index: 999;
        width: 100%;

        background-color: white;
        padding: 4px 8px;
        border-radius: 0.25rem;

        border-top-left-radius: 0rem;
        border-top-right-radius: 0rem;

        box-shadow: 8px 8px 8px rgba(0, 0, 0, 0.3);
    }

    .noBorderBottom {
        border-bottom-left-radius: 0rem;
        border-bottom-right-radius: 0rem;
    }

    .borderShowResults {
        box-shadow: 8px 8px 8px rgba(0, 0, 0, 0.3);
        border-bottom-left-radius: 0rem !important;
        border-bottom-right-radius: 0rem !important;
    }

    .fade-enter-active, .fade-leave-active {
        transition: opacity 0.2s;
    }

    .fade-enter, .fade-leave-to {
        opacity: 0;
    }
</style>