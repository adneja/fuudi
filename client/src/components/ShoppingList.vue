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
            <div class="list mb-4" v-if="shoppingList.length > 0">
                <div v-for="(item, index) in shoppingList" v-bind:key="index">
                    <div 
                        class="pointer normalFont letter-spacing item d-flex justify-content-between align-items-center"
                        @click="checkItem(item)">

                        <div class="d-flex justify-content-start align-items-center">
                            <div class="cb-container pointer mr-1">
                                <div class="cb">
                                    <i v-if="item.checked" class="fas fa-check cb-check"></i>
                                </div>
                            </div>  

                            <div>
                                <span>{{item.fooditem_name}}</span>
                            </div>
                        </div>
                        
                        <div>
                            <!--
                            <span class="mr-1">{{item.total}}</span>
                            <span>{{item.standardized_measurement}}</span>
                            -->
                            {{formatAmount(item.standardized_measurement, item.total)}}
                        </div>
                    </div>

                    <hr v-if="index !== shoppingList.length - 1">
                </div>
            </div>

            <!-- Clear buttons -->
            <div class="buttons" v-if="shoppingList.length > 0">
                <div class="d-flex justify-content-between">
                    <button @click="deleteShoppinglist(false)" class="btn btn-outline-light delete-button">
                        <i class="fas fa-tasks mr-2"></i>
                        <span>Delete checked</span>
                    </button>

                    <button @click="deleteShoppinglist(true)" class="btn btn-outline-light delete-button">
                        <i class="fas fa-shopping-basket mr-2"></i>
                        <span>Delete all</span>
                    </button>
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

            deleteShoppinglist(all) {
                this.$store.dispatch('deleteShoppingList', {
                    all: all
                })
                .then((response) => {
                    this.$store.commit('setShoppingList', response);
                })
                .catch((err) => {
                    console.log(err);
                });
            },

            checkItem(item) {
                this.$store.dispatch('checkShoppingListItem', {
                    check: item.checked === null,
                    fooditem_id: item.fooditem_id
                })
                .then((response) => {
                    this.$store.commit('setShoppingList', response);
                })
                .catch((err) => {
                    console.log(err);
                });
            },

            formatAmount(measurement, amount) {
                if(measurement === 'ml') {
                    let dl = amount / 100;
                    return dl >= 1 ? dl + ' dl' : amount + ' ml';
                } else if(measurement === 'g') {
                    let kg = amount / 1000;
                    return kg >= 1 ? kg + ' kg' : amount + ' g'
                } else {
                    return amount + ' ' + measurement;
                }
            }
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
        //border-top: 1px solid @main-background-dark;
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
        max-height: calc(100% - 122px);
        overflow-y: auto;
        border-top: 1px solid @main-background-dark;
        border-bottom: 1px solid @main-background-dark;

        hr {
            opacity: 1;
            margin-top: 0px;
            margin-bottom: 0px;
        }

        .item  {
            color: @main-color;
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
        color: @main-color;
    }

    .btn-outline-light {
		border-color: @main-color;
        color: @main-background;
        background-color: @main-color;
    }
    
	.btn-outline-light:hover {
		border-color: @main-color;
        color: @main-background;
        background-color: @main-color;
	}

	.btn-outline-light:active {
		border-color: @main-color;
        color: @main-background;
        background-color: @main-color;
        outline: none !important;
        
    }
    
    .btn-outline-light:focus {
		border-color: @main-color;
        color: @main-background;
        background-color: @main-color;
    }

    .delete-button {
        width: calc(50% - 10px);
    }
</style>