<template>
    <div class="window">
        <div class="title-container" v-if="title || icon">
            <span class="title">
                <i v-if="icon" v-bind:class="[icon]" class="mr-2"></i>
                <span>{{title}}</span>
            </span>
        </div>

        <div class="body" v-bind:class="[!title && !icon ? 'noTitleBar' : '']">
            <slot></slot>
        </div>
    </div>
</template>


<script>
    export default {
        name: 'Window',
        props: ['title', 'icon']
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .title-container {
        background-color: @main-background;
        padding: 7px 18px;
        //padding-bottom: 0px;
        //border-top-left-radius: 0.25rem;
        //border-top-right-radius: 0.25rem;
        //box-shadow: 2px 2px 7px rgba(0, 0, 0, 0.2);
    }

    .title {
        color: @main-color;
    }

    .body {
        color: @main-background;
        //box-shadow: 2px 2px 7px rgba(0, 0, 0, 0.2);
        //background-color: @main-color;
        //background-color: rgba(224, 234, 236, 0.9);
        padding: 28px 18px;
        //border-bottom-left-radius: 0.25rem;
        //border-bottom-right-radius: 0.25rem;

        border: 1px solid @main-background;
        border-top: none;
    }

    .noTitleBar {
        //border-top-left-radius: 0.25rem !important;
        //border-top-right-radius: 0.25rem !important;
    }
</style>