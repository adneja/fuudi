<template>
    <div class="placeholder">
        <div 
            v-for="index in amount" v-bind:key="index"
            class="pulse"
            v-bind:style="style"></div>
    </div>
</template>


<script>
    export default {
        name: 'placeholder',

        props: {
            height: String,
            amount: Number,
            spacing: Number
        },

        computed: {
            style() {
                return {
                    'height': this.height,
                    'width': '100%',
                    'margin-bottom': `${this.spacing}px`
                }
            }
        }
    }
</script>


<style lang="less" scoped>
    .pulse {
        background-color: rgba(227, 234, 235, 0.63);
        animation-name: color;
        animation-duration: 1s;
        animation-iteration-count: infinite;
    }

    @keyframes color {
        0% {
            background-color: rgba(227, 234, 235, 0.63);
        }
        50% {
            background-color: rgb(218, 225, 226);
        }
        100% {
            background-color: rgba(227, 234, 235, 0.63);
        }
    }
</style>