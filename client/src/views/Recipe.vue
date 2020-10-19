<template>
    <div class="recipe">
        <div class="recipe-container px-md-5 py-md-4 px-4 py-4">
            {{id}}
        </div>
    </div>
</template>


<script>
    export default {
        name: 'Recipe',
        props: ['id'],

        data() {
            return {

            }
        },

        activated() {
            console.log('active af');
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .recipe {
        margin-top: 48px;
    }

    .recipe-container {
        width: 100%;
        max-width: @main-content-width;
    }
</style>