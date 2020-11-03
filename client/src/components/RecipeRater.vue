<template>
    <div class="rate">
        <textarea class="w-100 form-control input-border" rows="2" placeholder="Comment" v-model="comment"></textarea>
        <div class="flex-between-center mt-3">
            <div class="font-l">
                <span 
                    v-for="index in max" 
                    v-bind:key="index" 
                    @mouseenter="hoverIndex = index" 
                    @mouseleave="hoverIndex = null"
                    @click="selectIndex(index)"
                    class="cursor-pointer">

                    <i v-if="fillStar(index)" class="fas fa-star"></i>
                    <i v-else class="far fa-star"></i>
                </span>

                <span class="ml-2 rating">{{hoverIndex || selectedIndex}}</span>
            </div>

            <button @click="rate" class="btn btn-primary">
                <i v-if="rating" class="fas fa-circle-notch fa-spin"></i>
                <span v-else>Submit</span>
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
                comment: '',
                rating: false
            }
        },

        methods: {
            fillStar(index) {
                if(this.hoverIndex) {
                    return index <= this.hoverIndex;
                }
                
                if(this.selectedIndex) {
                    return index <= this.selectedIndex;
                }

                return false;
            },

            selectIndex(index)  {
                if(index === this.selectedIndex) {
                    this.selectedIndex = null;
                } else {
                    this.selectedIndex = index;
                }   
            },

            rate() {
                this.rating = true;

                this.$store.dispatch('recipesRatingsInsert', {
                    recipeId: this.recipeId,
                    rating: this.selectedIndex,
                    comment: this.comment
                })
                .then((response) => {
                    this.$store.commit('setSystemMessage', {
                        content: `You gave this recipe ${this.selectedIndex} stars!`,
                        error: false
                    });

                    this.$emit('rated', response);
                    this.hoverIndex = null;
                    this.selectedIndex = null;
                    this.comment = '';
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                })
                .finally(() => {
                    this.rating = false;
                });
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/styles/custom.less";
</style>