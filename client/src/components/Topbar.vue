<template>
    <div class="topbar d-flex justify-content-center">
        <div class="topbar-content px-md-5 px-4">
            <div class="d-flex justify-content-between align-items-center">
                <div class="left d-flex justify-content-start align-items-center">
                    <!-- Logo -->
                    <div class="logo">
                        <router-link to="/" title="Home" class="d-flex justify-content-start align-items-center">
                            <i class="fas fa-hamburger mr-1"></i>
                            <span>Fuudi</span>
                        </router-link>
                    </div>

                    <!-- Desktop menu items -->
                    <div class="ml-4 d-md-block d-none desktop-items">
                        <router-link to="/recipes" title="Browse all recipes" class="menu-item-desktop mr-3">
                            <span>Recipes</span>
                        </router-link>

                        <router-link to="/plans" title="My meal plans" class="menu-item-desktop mr-3">
                            <span>Plans</span>
                        </router-link>
                    </div>
                </div>
                
                <!-- Right side of navbar -->
                <div class="right d-flex justify-content-end align-items-center">
                    <div v-if="$store.getters.shoppingList.length > 0" @click="showShoppingList" class="pointer d-flex justify-content-start align-items-center shopping-basket-container" title="Shopping list">
                        <i class="fas fa-shopping-basket shopping-basket mr-1"></i>

                        <span
                            v-if="$store.getters.shoppingList.length > 0" 
                            class="counter d-flex justify-content-center align-items-center ">
                            ({{$store.getters.shoppingList.length}})
                        </span>                        
                    </div>
                    

                    <div class="d-md-flex  d-none justify-content-end align-items-center">
                        <div @click="showLogin" title="Log in" class="menu-item-desktop pointer mr-3" v-if="!$store.getters.token">
                            <i class="fas fa-sign-in-alt mr-1"></i>
                            <span>Login</span>
                        </div>

                        <span v-else class="d-flex justify-content-end align-items-center">
                            <span title="User menu" @click="$store.commit('setShowUserMenu', true)" class="name pointer d-flex justify-content-end align-items-center">
                                <span>{{$store.getters.userData.name}}</span>
                                <i class="far fa-user-circle profile-img ml-2"></i>
                            </span>
                        </span>
                    </div>

                    <!-- Mobile menu button-->
                    <div class="d-md-none d-flex justify-content-end align-items-center">
                        <i @click="$store.commit('setShowMobileMenu', true)" class="fas fa-bars menu-button"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'Topbar',

        methods: {
            logout() {
                this.$store.dispatch('logout', this.$route)
                .then((response) => {
                    if(response) {
                        this.$router.push({name: 'Home'});
                    }
                });
            },

            showLogin() {
                this.$store.commit('setShowLoginSidebar', true);
            },

            showShoppingList() {
                this.$store.commit('setShowShoppingList', true);
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
        //box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
    }

    .topbar-content {
        width: @main-content-width;
        padding: @main-padding-vertical;
        position: relative;
    }

    .arrow {
        z-index: 99;
    } 

    .profile-img {
        font-size: 16pt;
        margin-top: -1px;
    }

    .logo, .menu-button {
        font-size: 14pt;
    }

    a {
        color: inherit;
    }

    a:hover {
        text-decoration: none;
        color: inherit;
    }

    .menu-item-desktop {
        font-size: 14pt;
        opacity: 0.6;
    }

    .name {
        font-size: 14pt;
    }

    .router-link-active {
        opacity: 1 !important;
    }

    .menu-item-desktop:hover {
        opacity: 1;
    }

    .location {
        font-size: 14pt;
    }

    .shopping-basket-container {
        position: relative;
        margin-right: 25px;
        opacity: 0.6;

        .counter {
            /*
            position: absolute;
            top: 8px;
            left: 8px;
            color: @main-color;
            width: 23px;
            height: 19px;
            padding-top: 2px;
            font-size: 12pt;
            pointer-events: none;

            display: flex;
            justify-content: center;
            align-items:center;
            */
        }
    }

    .shopping-basket {
        font-size: 14pt;
        //opacity: 0.6;
        margin-top: -3px;
    }

    .shopping-basket-container:hover {
        opacity: 1;
    }
</style>