<template>
    <div>
        <div class="font-l mb-1 font-primary">Instructions</div>

        <div class="customshadow">
            <div class="input-group">
                <input @keydown.enter="add" v-model="newInstruction" class="form-control customshadow" placeholder="New instruction">
                <button @click="add" class="btn btn-primary"><i class="fas fa-plus"></i></button>
            </div>
        </div>

        <div class="card-inverted mt-2 font-normal font-m flex-start-center" v-for="(instruction, index) in instructions" :key="index">
            <div class="w-100 flex-start-center">
                <span class="font-faded ml-3">{{index + 1}}.</span>
                <input class="form-control" v-model="instruction.instruction">
            </div>
            <button @click="remove(index)" class="btn btn-secondary"><i class="fas fa-times"></i></button>
        </div>
    </div>
</template>

<script>
    import Window from '../Window.vue';

    export default {
        name: 'recipecreatorinstructions',

        components: {
            Window
        },

        data() {
            return {
                newInstruction: '',
                instructions: []
            }
        },

        methods: {
            add() {
                this.instructions.push({instruction: this.newInstruction});
                this.newInstruction = '';
            },

            remove(index) {
                this.instructions.splice(index, 1);
            }
        }
        
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";
</style>    