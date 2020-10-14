<template>
    <div class="logout">
        <div class="back">
            <router-link to="/">
                <i class="fas fa-caret-left mr-1"></i>
                <span>Home</span>
            </router-link>
        </div>

        <div class="h-100 d-flex justify-content-center align-items-md-center align-items-top pt-md-0 pt-5">
            <div class="logout-container">
                <div class="card logout-card">
                    <div class="text-center message">You have been logged out.</div>
                    
                    <router-link to="/">
                        <button class="btn btn-success mb-2 w-100">Return to home page</button>
                    </router-link>

                    <div class="d-flex justify-content-center">
                        <small class="mr-2">
                            <router-link to="/signin">
                                Log in
                            </router-link>
                        </small>

                        <small class="ml-2">
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
        name: 'logout',

        data() {
            return {
  
            }
        },

        methods: {
            logout() {
                this.$store.dispatch('logout');
                this.showUserMenu = false;
                this.showMobileMenu = false;
            }
        },

        mounted() {
            this.logout();
        },

        activated() {
            this.logout();
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

    .logout {
        height: 100%;
        background-color: @main-background;
        padding: 20px;
    }

    .logout-container {
        width: 100%;
        max-width: 450px;
    }
    
    .logout-card {
        padding: 40px;
        border: none;
        color: @main-background;
    }

    .message {
        font-size: 16pt;
        margin-bottom: 20px;
    }

    .title {
        font-size: 35pt;
        color: @main-color;
        margin-bottom: 10px;
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