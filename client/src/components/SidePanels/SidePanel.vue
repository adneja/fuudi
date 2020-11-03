<template>
    <div class="sidepanel h-100 w-100" v-bind:class="[fixedClass]">
        <div class="h-100" v-bind:class="[absoluteClass, cardClass]" v-bind:style="panelWidth">
            <div class="px-4 py-3 font-xl flex-between-center header">
                <div>
                    <i class="mr-2" v-bind:class="[icon]"></i>
                    <span>{{title}}</span>
                </div>

                <i title="close" class="fas fa-times cursor-pointer" @click="$emit('close')"></i>
            </div>

            <div class="px-4 body">
                <slot></slot>
            </div>

            <div class="footer px-4 py-3 text-center">
                <slot name="footer"></slot>
            </div>
        </div>

        <div class="empty h-100" @click="$emit('close')"></div>
    </div>
</template>

<script>
    export default {
        name: 'sidepanel',

        props: {
            title: String,
            icon: String,
            location: String, // left || right
            width: String,
            colors: String // main || inverted
        },

        computed: {
            panelWidth() {
                return {
                    'width': '100%',
                    'max-width': this.width
                }
            },

            fixedClass() {
                return `fixed-top-${this.location}`;
            },

            absoluteClass() {
                return `absolute-top-${this.location}`;
            },

            cardClass() {
                return `card-${this.colors}`;
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";

    .empty {
        width: auto;
    }

    .header {
        border-bottom: 1px solid rgba(0, 0, 0, 0.2);
    }

    .body {
        height: calc(100% - 135px);
        overflow-y: auto;
        padding-top: 30px;
        padding-bottom: 30px;
       
    }

    .footer {
        border-top: 1px solid rgba(0, 0, 0, 0.2);
    }
</style>    