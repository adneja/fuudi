<template>
    <div class="signin" v-on:keyup.enter="login">
        <div class="back">
            <router-link to="/">
                <i class="fas fa-caret-left mr-1"></i>
                <span>Home</span>
            </router-link>
        </div>

        <div class="h-100 d-flex justify-content-center align-items-md-center align-items-top pt-md-0 pt-5">
            <div class="signin-container">
                <div class="card signin-card">
                    <!-- Logo -->
                    <div class="title text-center">
                        <router-link to="/" title="Home">
                            <i class="fas fa-carrot mr-1"></i>
                            <span>Mealplan</span>
                        </router-link>
                    </div>

                    <!-- Email -->
                    <div class="mb-2">
                        <div class="d-flex justify-content-between">
                            <div class="text-muted">Email</div>
                            <small class="text-muted">{{loginError}}</small>
                        </div>
                        <input autofocus type="email" class="form-control" placeholder="" v-model="email">
                    </div>
                    
                    <!-- Password -->
                    <div class="mb-4">
                        <div class="text-muted">Password</div>
                        <input type="password" class="form-control" placeholder="" v-model="password">
                    </div>

                    <!-- Login button -->
                    <button v-on:click="login" class="btn btn-success mb-2" v-bind:disabled="!readyToLogin">
                        <i v-if="loggingIn" class="fas fa-circle-notch fa-spin"></i>
                        <span v-else>Log In</span>
                    </button>
                    
                    <div class="d-flex justify-content-between">
                        <small>
                            <router-link to="/resetpassword">
                                Forgot your password?
                            </router-link>
                        </small>

                        <small>
                            <router-link to="/register">
                                Register
                            </router-link>
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
   
</template>


<script>
    export default {
        name: 'singin',

        data() {
            return {
                email: '',
                password: '',
                loginError: null,
                loggingIn: false
            }
        },

        computed: {
            validEmail() {
                return /^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$/.test(this.email);
            },

            validPassword() {
                return this.password.length > 5;
            },

            readyToLogin() {
                return this.validEmail && this.validPassword;
            }
        },

        methods: {
            login() {
                if(this.readyToLogin) {
                    this.loginError = null;
                    this.loggingIn = true;

                    this.$store.dispatch('login', {
                        email: this.email,
                        password: this.password
                    })
                    .then((response) => {
                        this.$store.commit('setUserData', response.userData);
                        this.$store.commit('setToken', response.token);
                        this.$router.push({name: 'Home'});
                    })
                    .catch((err) => {
                        //this.loginError = err;
                        console.log(err);

                        this.$store.commit('setSystemMessage', {
                            content: err,
                            error: true
                        });
                    })
                    .finally(() => { 
                        this.loggingIn = false;
                    });
                }
            }
        },

        watch: {
            email() {
                this.loginError = null;
            },

            password() {
                this.loginError = null;
            }
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .signin {
        height: 100%;
        background-color: @main-background;
        padding: 20px;
    }

    .signin-container {
        width: 100%;
        max-width: 400px;
    }
    
    .signin-card {
        padding: 40px;
        border: none;
    }

    .title {
        font-size: 35pt;
        color: @main-color;
        margin-bottom: 40px;
        //margin-top: -40px;
        color: @main-background;

        a {
            text-decoration: none;
        }

        a:focus {
            text-decoration: none !important;
        }
    }

    a {
        color: inherit;
    }

    a:focus {
        text-decoration: underline !important;
        outline: none !important;
    }

    small {
        color: @main-background;
    }

    .back {
        color: @main-color;
        position: absolute;
        top: 20px;
        left: 20px;
    }
</style>