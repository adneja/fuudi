<template>
    <div class="topbar d-flex justify-content-center">
        <div class="topbar-content">
            <div class="d-flex justify-content-between align-items-center">
                <div class="left d-flex justify-content-start align-items-center">
                    <!-- Logo -->
                    <div class="logo">
                        <router-link to="/" title="Home">
                            <i class="fas fa-carrot mr-1"></i>
                            <span>Mealplanner</span>
                        </router-link>
                    </div>

                    <!-- Desktop menu items -->
                    <div class="ml-4 d-md-block d-none">
                        <router-link to="/recipes" title="Browse all recipes" class="menu-item-desktop mr-3">
                            <span>RECIPES</span>
                        </router-link>

                        <router-link to="/plans" title="My meal plans" class="menu-item-desktop mr-3">
                            <span>PLANS</span>
                        </router-link>
                    </div>
                </div>
                
                <!-- Right side of navbar -->
                <div class="right">
                    
                    <!-- Desktop: Login/profile button -->
                    <div class="d-md-block d-none">
                        <router-link to="/signin" title="Sign in" class="menu-item-desktop mr-3" v-if="!$store.getters.token">
                            <span>LOGIN</span>
                        </router-link>

                        <router-link to="/register" title="Register" class="menu-item-desktop" v-if="!$store.getters.token">
                            <span>REGISTER</span>
                        </router-link>

                        <span class="user-menu d-flex justify-content-start align-items-center" v-else v-on:click="showUserMenu = !showUserMenu">
                            <span>{{$store.getters.userData.name}}</span>
                            <i class="fas fa-user-circle ml-2 profile-img"></i>
                        </span>
                    </div>

                    <!-- Mobile menu button-->
                    <div class="d-md-none d-block">
                        <i v-if="!showMobileMenu" v-on:click="showMobileMenu = true" class="fas fa-bars menu-button"></i>
                        <i v-else v-on:click="showMobileMenu = false" class="fas fa-times menu-button"></i>
                    </div>
                </div>
            </div>

            <!-- Mobile menu -->
            <div class="mobile-menu d-md-none d-block" v-if="showMobileMenu">
                <div class="menu-item-mobile">
                    <router-link to="/recipes" title="Recipes">
                        <span>RECIPES</span>
                    </router-link>
                </div>

                <div class="menu-item-mobile">
                    <router-link to="/plans" title="Plans">
                        <span>PLANS</span>
                    </router-link>
                </div>
                
                <hr>

                <div v-if="!$store.getters.token">
                    <div class="menu-item-mobile">
                        <router-link to="/signin" title="Sign in">
                            <span>LOGIN</span>
                        </router-link>
                    </div>

                    <div class="menu-item-mobile">
                        <router-link to="/register" title="Register">
                            <span>REGISTER</span>
                        </router-link>
                    </div>
                </div>

                <div v-else>
                    <div class="d-flex justify-content-start align-items-center mb-2">
                        <!--<i class="fas fa-user-circle mr-2 profile-img"></i>-->
                        <span>{{$store.getters.userData.name}}</span>
                    </div>

                    <div class="menu-item-mobile">
                        <router-link to="/settings">SETTINGS</router-link>
                    </div>

                    <div class="menu-item-mobile">
                        <router-link to="/logout">LOG OUT</router-link>
                    </div>
                </div>
            </div>
            
            <!-- Desktop profile dropdown menu -->
            <div class="user-menu-desktop" v-if="showUserMenu">
                <div class="text-right pr-2 arrow"><i class="fas fa-caret-up fa-2x"></i></div>

                <ul class="list-group">
                    <router-link class="list-group-item" to="/settings">Settings</router-link>
                    <router-link class="list-group-item text-danger" to="/logout">Log out</router-link>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'topbar',

        data() {
            return {
                showMobileMenu: false,
                showUserMenu: false
            }
        },

        methods: {
            logout() {
                this.$store.dispatch('logout');
                this.showUserMenu = false;
                this.showMobileMenu = false;
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/global.less";

    .topbar {
        background-color: @main-background;
        color: @main-color;
        position: fixed;
        top: 0px;
        left: 0px;
        width: 100%;
        z-index: 99999;
    }

    .topbar-content {
        width: @main-content-width;
        padding: @main-padding-vertical @main-padding-horizontal;
        position: relative;
    }

    .arrow {
        z-index: 99;
    }

    .user-menu:hover {
        cursor: pointer;
    }

    .profile-img {
        font-size: 16pt;
    }

    .user-menu-desktop {
        position: absolute;
        top: 28px;
        right: 13px;
        width: 150px;
        z-index: 999;

        ul {
            margin-top: -17px;
            z-index: 9;
        }

        .list-group-item {
            //color: @main-background;
            color: #343a40;
            padding: 7px 10px;
        }

        .list-group-item:hover {
            background-color: @main-background; //#343a40
            color: @main-color !important;
            cursor: pointer;
        }
    }

    .logo, .menu-button {
        font-size: 15pt;
    }

    a {
        color: inherit;
    }

    a:hover {
        text-decoration: none;
    }

    .menu-item-desktop {
        font-size: 11pt;
        opacity: 0.6;
    }

    .router-link-active {
        opacity: 1;
    }

    .menu-item-desktop:hover {
        opacity: 1;
    }

    .menu-item-mobile {
        margin-bottom: 10px;
        opacity: .6;
    }

    .mobile-menu {
        background-color: @main-background;
        width: 100%;
        //height: 100%;
        position: absolute;
        top: 50px;
        left: 0px;
        padding: @main-padding-horizontal;
    }

    hr {
        border-top: 1px solid rgb(38, 66, 55);
            
    }
</style>