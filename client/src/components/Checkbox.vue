<template>
    <div class="checkbox">
        <div class="cb-container cursor-pointer" @click="status = !status">
            <div class="cb">
                <i v-if="status" class="fas fa-check cb-check"></i>
            </div>
        </div>
    </div>
</template>


<script>
    export default {
        name: 'checkbox',

        props: {
            initialStatus: Boolean
        },

        data() {
            return {
                status: this.initialStatus || false
            }
        },

        watch: {
            status() {
                this.$emit('changed', this.status);
            }
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/styles/custom.less";

    .cb-container {
        display: flex;
    }

    .cb {	
        width: 25px;
        height: 25px;
        border: 1px solid @main-background;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-right: 5px;
        background-color: @main-color;
    }

    .cb-label {
        opacity: 0.8;
        font-size: 12pt;
    }

    .cb-check {
        color: @main-background;
    }
</style>