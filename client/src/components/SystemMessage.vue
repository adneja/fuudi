<template>
    <div class="systemmessage">
        <div 
            class="content h-100 d-flex justify-content-center align-items-center"
            v-bind:class="[error ? 'error' : 'success']">
            {{currentMessage}}
        </div>
    </div>
</template>

<script>
    export default {
        name: 'SystemMessage',

        data() {
            return {
                currentMessage: '',
                error: false
            }
        },

        computed: {
            systemMessage() {
                return this.$store.getters.systemMessage;
            }
        },

        watch: {
            systemMessage() {
                if(this.systemMessage !== null) {
                    this.currentMessage = this.systemMessage.content;
                    this.error = this.systemMessage.error;

                    setTimeout(() => {
                        this.$store.commit('setSystemMessage', null);
                    }, 3000);
                }
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/global.less";

    .systemmessage {
        position: fixed;
        top: 0px; 
        right: 0px;
        width: 100%;
        height: 48px;
        z-index: 999999999999;
        color: white;
    }

    .error {
        background-color: #aa4f4f;
    }

    .success {
        background-color: rgb(67, 116, 86);
    }
</style>