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
        //background-color: @main-background-dark;
        padding: 15px 20px;
        padding-bottom: 0px;
        border-top-left-radius: 0.25rem;
        border-top-right-radius: 0.25rem;
    }

    .title {
        color: @main-color;
        //opacity: 0.6;
    }

    .body {
        color: @main-color;
        background-color:@main-background;//rgba(53, 124, 91, 0.03);//rgb(247, 247, 247);
        padding: 20px;
        //padding-top: 5px;
        border-bottom-left-radius: 0.25rem;
        border-bottom-right-radius: 0.25rem;
    }

    .noTitleBar {
        border-top-left-radius: 0.25rem !important;
        border-top-right-radius: 0.25rem !important;
    }
</style>