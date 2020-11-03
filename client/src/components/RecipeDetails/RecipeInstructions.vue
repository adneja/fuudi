<template>
    <div class="recipeinstructions card-inverted p-3" v-if="instructions">
        <!--<Window title="Instructions" icon="fas fa-list-ol">-->
            <div class="font-normal flex-start-start mb-1" v-for="(instruction, index) in instructions" :key="index">
                <div class="font-faded mr-2">{{instruction.number}}. </div>
                <div>{{instruction.instructions}}</div>
            </div>
        <!--</Window>-->
    </div>
</template>

<script>
    import Placeholder from '../Placeholder.vue';
    import Window from '../Window.vue';

    export default {
        name:'recipeinstructions',

        props: {
            id: Number
        },

        components: {
            Placeholder,
            Window
        },

        data() {
            return {
                instructions: null
            }
        },

        methods: {
            getInstructions() {
                this.$store.dispatch('recipesInstructionsGet', {
                    id: this.id
                })
                .then((response) => {
                    this.instructions = response;
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                });
            },
        },

        mounted() {
            this.getInstructions();
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";
</style>