<template>
    <div class="window">
        <div class="title-container" v-if="title || icon">
            <span class="title d-flex justify-content-between">
                <span>
                    <i v-if="icon" v-bind:class="[icon]" class="mr-2"></i>
                    <span>{{title}}</span>
                </span>

                <slot name="titlebar"></slot>
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
        padding: 8px 16px;
        box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
    }

    .title {
        color: @main-color;
    }

    .body {
        color: @main-background;
        box-shadow: 0px 0px 4px rgba(0, 0, 0, 0.3);
        padding: 16px 16px;
        border-top: none;
        background-color: white;
    }
</style>