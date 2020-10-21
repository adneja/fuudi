<template>
    <div class="rate">
        <textarea class="form-control" rows="2" placeholder="Comment" v-model="comment"></textarea>
        <div class="d-flex justify-content-between align-items-center mt-3">
            <div>
                <span 
                    v-for="index in max" 
                    v-bind:key="index" 
                    @mouseenter="hoverIndex = index" 
                    @mouseleave="hoverIndex = null"
                    @click="selectIndex(index)">

                    <i v-if="index <= hoverIndex || index <= selectedIndex" class="fas fa-star"></i>
                    <i v-else class="far fa-star"></i>
                </span>

                <span class="ml-2 rating">{{hoverIndex || selectedIndex}}</span>
            </div>

            <button 
                @click="rate" 
                class="btn btn-outline-light d-flex justify-content-start align-items-center">
                
                <i class="fas fa-check mr-1"></i>
                <span>Submit</span>
            </button>
        </div>
    </div>
</template>

<script>
    export default {
        name:'rate',
        props: {
            max: Number,
            recipeId: Number
        },

        data() {
            return {
                hoverIndex: null,
                selectedIndex: null,
                comment: ''
            }
        },

        methods: {
            selectIndex(index)  {
                if(index === this.selectedIndex) {
                    this.selectedIndex = null;
                } else {
                    this.selectedIndex = index;
                }   
            },

            rate() {
                this.$store.dispatch('rateRecipe', {
                    id: parseInt(this.recipeId),
                    rating: this.selectedIndex,
                    comment: this.comment
                })
                .then((response) => {
                    this.$store.commit('setSystemMessage', {
                        content: `You gave this recipe ${this.selectedIndex} stars!`,
                        error: false
                    });

                    this.$emit('rated');
                    this.hoverIndex = null;
                    this.selectedIndex = null;
                    this.comment = '';
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/global.less";

    i {
        font-size: 16pt;
    }

    i:hover {
        cursor: pointer;
    }

    .rating  {
        font-size: 14pt;
    }

    .btn-outline-light {
		border-color: @main-background;
		color: @main-background;
	}

	.btn-outline-light:hover {
		background-color: @main-background;
		color: @main-color;
	}

	.btn-outline-light:active {
		background-color: @main-background-dark !important;
		border-color: @main-background-dark !important;
		color: @main-color !important;
    }

    textarea  {
        border-color: @main-background;
    }

    textarea:focus  {
        border-color: @main-background !important;
    }
</style>