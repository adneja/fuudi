<template>
    <div class="login" v-on:keyup.enter="submit">
        <div class="login-panel">
            <!-- Title -->
            <div class="title d-flex justify-content-between align-items-center mb-4">
                <div v-if="showRegister">
                    <span>Register</span>
                </div>
                <div v-else>
                    <span v-if="$store.getters.loginRedirect">Login required</span>
                    <span v-else>Login</span>
                </div>

                <button class="btn textButton" v-on:click="close">
                    <i class="fas fa-times closeButton"></i>
                </button>
            </div>

            <!-- Email -->
            <input 
                v-model="email" 
                ref="email"
                autofocus 
                type="email" 
                class="form-control form-control-sm mb-3" 
                placeholder="Email">

            <!-- Name -->
            <input 
                v-model="name" 
                v-if="showRegister" 
                autofocus 
                type="text" 
                class="form-control form-control-sm mb-3" 
                placeholder="Name">

            <!-- Password -->
            <input 
                v-model="password" 
                type="password" 
                class="form-control form-control-sm" 
                placeholder="Password">

            <!-- Reapeat password-->
            <input 
                v-model="repeatPassword" 
                v-if="showRegister" 
                type="password" 
                class="form-control form-control-sm mt-3" 
                placeholder="Repeat password">

            <button 
                v-on:click="submit" 
                class="btn btn-outline-light w-100 mb-1 mt-4">
                <i v-if="loading" class="fas fa-circle-notch fa-spin"></i>
                <span v-else>Submit</span>
            </button>

            <div class="d-flex justify-content-between" v-if="!showRegister">
                <button class="btn textButton" v-on:click="forgotPassword = true">
                    <!--<small>Forgot you password?</small>-->
                    Forgot your password?
                </button>

                <button 
                    v-if="!showRegister" 
                    class="btn textButton" 
                    v-on:click="showRegister = true">
                    <!--<small>Register</small>-->
                    Register
                </button>
            </div>

            <div class="d-flex justify-content-center" v-else>
                <button 
                    class="btn textButton" 
                    v-on:click="showRegister = false">
                    <!--<small>Already have a user?</small>-->
                    Already have a user?
                </button>
            </div>
        </div>

        <div class="emptySpace" v-on:click="close"></div>
    </div>
</template>


<script>
    export default {
        name: 'Login',

        data() {
            return {
                email: '',
                name: '',
                password: '',
                repeatPassword: '',
                showRegister: false,
                forgotPassword: false,
                loading: false
            }
        },

        methods: {
            close() {
                this.$store.commit('setShowLoginSidebar', false);
                this.$store.commit('setLoginRedirect', null);
            },

           login() {
                this.loading = true;

                this.$store.dispatch('login', {
                    email: this.email,
                    password: this.password
                })
                .then((response) => {
                    this.$store.commit('setUserData', response.userData);
                    this.$store.commit('setToken', response.token);

                    this.$store.commit('setSystemMessage', {
                        content: `Logged in as ${response.userData.name}.`,
                        error: false
                    });
                    
                    if(this.$store.getters.loginRedirect) {
                        this.$router.push(this.$store.getters.loginRedirect);
                    }

                    this.close();
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                })
                .finally(() => { 
                    this.loading = false;
                });
                
            },

            register() {
                this.loading = true;

                this.$store.dispatch('register', {
                    email: this.email,
                    name: this.name,
                    password: this.password,
                    repeat_password: this.repeatPassword
                })
                .then((response) => {
                    this.$store.commit('setUserData', response.userData);
                    this.$store.commit('setToken', response.token);
                    
                    this.$store.commit('setSystemMessage', {
                        content: `Registered as ${response.userData.name}.`,
                        error: false
                    });

                    if(this.$store.getters.loginRedirect) {
                        this.$router.push(this.$store.getters.loginRedirect);
                    }

                    this.close();
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                })
                .finally(() => {
                    this.loading = false;
                });
            }, 

            submit() {
                if(this.showRegister) {
                    this.register();
                } else {
                    this.login();
                }
            },
        },

        activated() {
            this.$refs.email.focus();
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .login {
        position: fixed;
        top: 0px;
        right: 0px;
        height: 100vh;
        width: 100vw;
        z-index: 9999999;
    }

    .login-panel {
        position: absolute;
        top: 0px;
        right: 0px;
        height: 100vh;
        width: 100%;
        max-width: 430px;
        background-color: @main-background;
        box-shadow: 0px 0px 6px rgba(0, 0, 0, 0.3);
        z-index: 9999999;
        padding: 30px;
    }

    .emptySpace {
        width: auto;
        height: 100vh;
    }

    .closeButton {
        font-size: 20pt;
    }

    .title {
        font-size: 20pt;
        color: @main-color;

        button {
            width: 31px;
        }
    }
</style>