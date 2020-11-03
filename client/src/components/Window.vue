<template>
    <div class="window card-inverted">
        <div class="colors-main font-l flex-between-center px-md-4 px-3 py-2" v-if="title || icon">
            <span>
                <i v-if="icon" v-bind:class="[icon]" class="mr-2"></i>
                <span>{{title}}</span>
            </span>

            <slot name="titlebar"></slot>
        </div>

        <div class="p-md-4 p-3 font-m">
            <slot></slot>
        </div>
    </div>
</template>


<script>
    export default {
        name: 'Window',
        props: {
            title: String,
            icon: String
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/styles/custom.less";
</style>