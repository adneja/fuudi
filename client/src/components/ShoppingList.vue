<template>
    <div class="shoppinglist" ref="shoppinglist">
        <div class="shoppinglist-panel">
            <!-- Title -->
            <div class="title d-flex justify-content-between align-items-center mb-4">
                <div class="">Shopping list <span class="muted">({{shoppingList.length}})</span></div>

                <button class="btn textButton" @click="close">
                    <i class="fas fa-times closeButton"></i>
                </button>
            </div>
            
            <!-- Shopping list -->
            <div class="list mb-4">
                <div v-for="(item, index) in shoppingList" v-bind:key="index">
                    <div 
                        v-bind:class="{'newly-added': isNewlyAdded(item)}"
                        class="pointer normalFont letter-spacing item d-flex justify-content-between align-items-center"
                        @click="item.checked = !item.checked">

                        <div class="d-flex justify-content-start align-items-center">
                            <div class="cb-container pointer mr-1">
                                <div class="cb">
                                    <i v-if="item.checked" class="fas fa-check"></i>
                                </div>
                            </div>  

                            <div>
                                <span>{{item.fooditem_name}}</span>
                                <span class="font-weight-bold ml-2" v-if="isNewlyAdded(item)">(new)</span>
                            </div>
                        </div>
                        
                        <div>{{item.amount}}</div>
                    </div>

                    <hr v-if="index !== shoppingList.length - 1">
                </div>

                <div v-if="shoppingList.length === 0" class="normalFont letter-spacing empty">
                    Your shopping list is empty!<br>
                    Add items to the list from recipes or meal plans.
                </div>
            </div>

            <!-- Clear buttons -->
            <div class="buttons">
                <div class="btn-group w-100">
                    <button @click="removeChecked" class="btn btn-outline-light w-50"><i class="fas fa-tasks mr-2"></i>Clear checked</button>
                    <button @click="removeAll" class="btn btn-outline-light w-50"><i class="fas fa-shopping-basket mr-2"></i>Clear all</button>
                </div>
            </div>
        </div>

        <div class="emptySpace" @click="close"></div>
    </div>
</template>


<script>
    export default {
        name: 'shoppinglist',

        computed: {
            shoppingList() {
                return this.$store.getters.shoppingList;
            },

            newlyAddedItems() {
                return this.$store.getters.newlyAddedShoppingListItems;
            }
        },

        methods: {
            close() {
                this.$store.commit('setShowShoppingList', false);
            },

            removeAll() {
                this.$store.commit('removeAllShoppingListItems');
            },

            removeChecked() {
                this.$store.commit('removeCheckedShoppingListItems');
            },

            isNewlyAdded(item) { 
                return this.newlyAddedItems.indexOf(item) !== -1;
            }
        },

        mounted() {
            document.body.style.overflow = 'hidden';
        },

        unmounted() {
            document.body.style.overflow = 'auto';
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .shoppinglist {
        position: fixed;
        top: 0px;
        right: 0px;
        height: 100%;
        width: 100vw;
        z-index: 999999;
        color: @main-color;
    }

    .shoppinglist-panel {
        position: absolute;
        top: 0px;
        right: 0px;
        height: 100%;
        width: 100%;
        max-width: 500px;
        background-color: @main-background;
        box-shadow: 0px 0px 6px rgba(0, 0, 0, 0.3);
        z-index: 9999999;
        padding: 20px 20px;
    }

    .buttons {
        position: absolute;
        bottom: 0px;
        right: 0px;
        width: 100%;
        padding: 20px;
    }

    .emptySpace {
        width: auto;
        height: 100vh;
    }

    .title {
        font-size: 20pt;
        color: @main-color;

        button {
            width: 31px;
        }
    }

    .closeButton {
        font-size: 20pt;
    }   

    .list {
        height: 100%;
        max-height: calc(100% - 121px);
        overflow-y: scroll;
        background-color: @main-color;

        hr {
            opacity: 0.2;
            margin-top: 0px;
            margin-bottom: 0px;
        }

        .item  {
            color: @main-background;
            padding-left: 16px;
            padding-right: 16px;
            padding-top: 16px;
            padding-bottom: 16px;
        }
    }

    .item-padding {
        height: 16px;
    }

    .newly-added {
        background-color: rgba(227, 234, 235, 0.63);
    }

    .empty {
        color: @main-background;
        padding: 16px;
    }
</style>