<template>
    <div class="itemselector">
        <div class="d-flex justify-item-start flex-wrap">
            <div 
                v-for="(item, index) in items" 
                v-bind:key="index"
                class="badge badge-dark mr-2 my-1 pointer"
                v-bind:class="[markedItem === item ? 'underline' : '']"
                v-on:click="$emit('item-clicked', item);"
                v-on:mouseenter="markedItem = item">
                
                <span>{{item}}</span>
            </div>

            <div    
                class="badge badge-success mr-2 my-1 pointer"
                v-bind:class="[!markedItem ? 'underline' : '']"
                v-if="showAdd"
                v-on:mouseenter="markedItem = null">

                <i class="fas fa-plus mr-1"></i>
                <span class="mr-1">Add</span>
                <span>'{{target.trim()}}'</span>
            </div>
        </div>
    </div>
</template>


<script>
    export default {
        name: 'ItemSelector',
        props: ['items', 'target'],

        data() {
            return {
                markedItem: this.items[0] || null,
                showAdd: false
            }
        },

        computed: {
            markedItemIndex() {
                return this.items.indexOf(this.markedItem);
            }
        },

        methods: {
            getShowAdd() {
                if(this.target) {
                    return this.items.filter((item) => {
                        return item.toLowerCase() === this.target.trim().toLowerCase();
                    }).length === 0;
                } else {
                    return false;
                }
            },

            markItemRight() {
                if(this.markedItemIndex < (this.items.length - 1)) {
                    this.markedItem = this.items[this.markedItemIndex + 1];
                } else {
                    if(!this.markedItem) {
                        this.markedItem = this.items[0];
                    } else {
                        this.markedItem = null;
                    }
                    
                }
            },

            markItemLeft() {
                if(this.markedItemIndex > 0) {
                    this.markedItem = this.items[this.markedItemIndex - 1];
                } else {
                    if(!this.markedItem) {
                        this.markedItem = this.items[this.items.length - 1];
                    } else {
                        this.markedItem = null;
                    }
                }
            }
        },

        watch: {
            markedItem() {
                this.$emit('itemMarked', this.markedItem);
            },

            items() {
                this.markedItem = this.items[0];
                this.showAdd = this.getShowAdd();
            },
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .underline {
        text-decoration: underline;
    }
</style>