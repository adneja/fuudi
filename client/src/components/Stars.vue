<template>
    <div class="stars">
        <span v-for="(star, index) in numberOfStars" v-bind:key="index">
            <i v-bind:class="[starType(index)]"></i>
        </span>
    </div>
</template>


<script>
    export default {
        name: 'Stars',
        props: ['stars', 'max'],

        computed: {
            numberOfStars() {
                return new Array(parseInt(this.max));
            }
        },

        methods: {
            starType(starNumber) {
                let stars = parseFloat(this.stars),
                    diff = stars - starNumber;

                if(diff >= 1) {
                    return 'fas fa-star';
                } else if(diff > 0 && diff < 1) {
                    return 'fas fa-star-half-alt';
                } else if(diff <= 0) {
                    return 'far fa-star'
                }
            }
        }
    }
</script>


<style lang="less" scoped>
    i {
        font-size: 11pt;
    }
</style>