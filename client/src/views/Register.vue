<template>
    <div class="register" v-on:keyup.enter="register">
        <div class="back">
            <router-link to="/">
                <i class="fas fa-caret-left mr-1"></i>
                <span>Home</span>
            </router-link>
        </div>

        <div class="h-100 d-flex justify-content-center align-items-md-center align-items-top pt-md-0 pt-5">
            <div class="register-container">
                <div class="card register-card">
                    <!-- Logo -->
                    <div class="title text-center">
                        <router-link to="/" title="Home">
                            <i class="fas fa-carrot mr-1"></i>
                            <span>Mealplan</span>
                        </router-link>
                    </div>

                    <!-- Email -->
                    <div class="mb-2">
                        <div class="d-flex justify-content-between align-items-center text-muted">
                            <span>Email</span>

                            <small class="text-muted" v-if="emailError">{{emailError}}</small>
                            <small v-if="email.length > 0 && !emailError && !isTypingEmail">
                                <i class="fas fa-check"></i>
                            </small>
                        </div>

                        <input autofocus type="email" class="form-control" placeholder="" v-model="email">
                    </div>

                    <!-- Username -->
                    <div class="mb-2">
                        <div class="d-flex justify-content-between text-muted">
                            <span>Name</span>

                            <small class="text-muted" v-if="usernameError">{{usernameError}}</small>
                            <small v-if="username.length > 0 && !usernameError && !isTypingUsername">
                                <i class="fas fa-check"></i>
                            </small>
                        </div>

                        <input type="text" class="form-control" placeholder="" v-model="username">
                    </div>
                    
                    <!-- Password -->
                    <div class="mb-2">
                        <div class="d-flex justify-content-between text-muted">
                            <span>Password</span>
                            
                            <small class="text-muted" v-if="passwordError">{{passwordError}}</small>
                            <small v-if="password.length > 0 && !passwordError && !isTypingPassword">
                                <i class="fas fa-check"></i>
                            </small>
                        </div>
                        
                        <input type="password" class="form-control" placeholder="" v-model="password">
                    </div>

                    <!-- Reapeat password -->
                    <div class="mb-4">
                        <div class="d-flex justify-content-between text-muted">
                            <span>Repeat password</span>

                            <small class="text-muted" v-if="repeatPasswordError">{{repeatPasswordError}}</small>
                            <small v-if="repeatPassword.length > 0 && !repeatPasswordError && !isTypingReapeatPassword">
                                <i class="fas fa-check"></i>
                            </small>
                        </div>

                        <input type="password" class="form-control" placeholder="" v-model="repeatPassword">
                    </div>

                    <!-- Register button -->
                    <button v-on:click="register" class="btn btn-success mb-2" v-bind:disabled="!readyToRegister">
                        <i v-if="registering" class="fas fa-circle-notch fa-spin"></i>
                        <span v-else>Register</span>
                    </button>

                    <div class="d-flex justify-content-center">
                        <small>
                            <router-link to="/signin">
                                Already have a user?
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
        name: 'register',

        data() {
            return {
                email: '',
                isTypingEmail: false,
                currentEmailTimeout: null,
                emailError: null,

                username: '',
                isTypingUsername: false,
                currentUsernameTimeout: null,
                usernameError: null,

                password: '',
                isTypingPassword: false,
                currentPasswordTimeout: null,
                passwordError: null,

                repeatPassword: '',
                isTypingReapeatPassword: false,
                currentRepeatPasswordTimeout: null,
                repeatPasswordError: null,

                registering: false
            }
        },

        computed: {
            validEmail() {
                return this.email.length > 0 && !this.emailError && !this.isTypingEmail;
            },

            validName() {
                return this.username.length > 0 && !this.usernameError && !this.isTypingUsername;
            },  

            validPassword() {
                return this.password.length > 0 && !this.passwordError && !this.isTypingPassword;
            },

            validRepeatPassword() {
                return this.repeatPassword.length > 0 && !this.repeatPasswordError && !this.isTypingReapeatPassword;
            },

            readyToRegister() {
                return this.validEmail && this.validName && this.validPassword && this.validRepeatPassword;
            }
        },

        methods: {
            register() {
                if(this.readyToRegister) {
                    this.registering = true;

                    this.$store.dispatch('register', {
                        email: this.email,
                        name: this.username,
                        password: this.password
                    })
                    .then((response) => {
                        this.$store.commit('setUserData', response.userData);
                        this.$store.commit('setToken', response.token);
                        this.registering = false;
                        this.$router.push({name: 'Home'});
                    })
                    .catch((err) => {
                        console.log(err);
                    });
                }
            },

            isEmailValid() {
                return /^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$/.test(this.email);
            },
        },

        watch: {
            email() {
                this.isTypingEmail = true;
                this.emailError = null;

                clearTimeout(this.currentEmailTimeout);

                this.currentEmailTimeout = setTimeout(() => {
                    if(this.email.length > 0) {
                        this.email = this.email.trim();

                        if(!this.isEmailValid(this.email)) {
                            this.isTypingEmail = false;
                            this.emailError = 'Invalid email.';
                        } else {
                            this.$store.dispatch('validateEmail', {
                                email: this.email
                            })
                            .then((response) => {
                                if(response.user_exists) {
                                    this.emailError = 'Email is in use.';
                                } else {

                                }
                            })
                            .catch((err) => {
                                console.log(err);
                            })
                            .finally(() => {
                                this.isTypingEmail = false;
                            });
                        }
                    }
                }, 1000);
            },

            username() {
                this.isTypingUsername = true;
                this.usernameError = null;

                clearTimeout(this.currentUsernameTimeout);

                this.currentUsernameTimeout = setTimeout(() => {
                    this.isTypingUsername = false;
                    this.username = this.username.trim();

                    if(this.username.length > 0 && this.username.length < 3) {
                        this.usernameError = 'Username is too short.';
                    }
                }, 700);
            },

            password() {
                this.isTypingPassword = true;
                this.isTypingReapeatPassword = true;
                this.passwordError = null;
                this.repeatPasswordError = null;

                clearTimeout(this.currentPasswordTimeout);

                this.currentPasswordTimeout = setTimeout(() => {
                    this.isTypingPassword = false;
                    this.isTypingReapeatPassword = false;

                    if(this.password.length > 0 && this.password.length < 6) {
                        this.passwordError = 'Password is too short.';
                    }

                    if(this.repeatPassword.length > 0 && this.repeatPassword !== this.password)  {
                        this.repeatPasswordError = 'Passwords do not match.';
                    }
                }, 700);
            },

            repeatPassword() {
                this.isTypingReapeatPassword = true;
                this.repeatPasswordError = null;

                clearTimeout(this.currentRepeatPasswordTimeout);

                this.currentRepeatPasswordTimeout = setTimeout(() => {
                    this.isTypingReapeatPassword = false;

                    if(this.repeatPassword.length > 0 && this.repeatPassword !== this.password)  {
                        this.repeatPasswordError = 'Passwords do not match.';
                    }
                }, 700);
            }
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .register {
        height: 100%;
        background-color: @main-background;
        padding: 20px;
    }

    .register-container {
        width: 100%;
        max-width: 400px;
    }
    
    .register-card {
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