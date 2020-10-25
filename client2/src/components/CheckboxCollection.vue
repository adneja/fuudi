<template>
    <div class="checkboxcollection">
        <div 
            class="cb-container pointer mr-3 mb-2"
            v-for="item in items"
            v-bind:key="item.key"
            @click="item.checked = !item.checked">
            <div class="cb">
                <i v-if="item.checked" class="fas fa-check cb-check"></i>
            </div>
            <span class="cb-label">{{item.label}}</span>
        </div>
    </div>
</template>


<script>
    export default {
        name: 'CheckboxCollection',
        props: {
            checkboxItems: Array
        },

        data() {
            return {
                items: this.checkboxItems
            }
        },

        computed: {
            itemsStringified() {
                return JSON.stringify(this.items);
            }
        },

        watch: {
            itemsStringified() {
                this.$emit('change', this.items);
            }
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";
</style>