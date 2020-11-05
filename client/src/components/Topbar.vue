<template>
    <div class="flex-center-start colors-main fixed-top-left w-100">
        <div class="topbar-content px-md-5 px-3">
            <div class="flex-between-center">
                <div class="left flex-start-center">
                    <!-- Logo -->
                    <div class="logo">
                        <router-link to="/" title="Home" class="flex-start-center">
                            <i class="fas fa-hamburger mr-1"></i>
                            <span>Fuudspace</span>
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
                    <div @click="showShoppingList" class="pointer flex-start-center shopping-basket-container" title="Shopping list">
                        <i class="fas fa-shopping-basket shopping-basket mr-1"></i>
                        <span class="counter flex-center-center">
                            ({{$store.getters.shoppingList.length}})
                        </span>                        
                    </div>
                    
                    <div class="d-md-flex d-none justify-content-end align-items-center">
                        <div @click="showLogin" title="Log in" class="menu-item-desktop pointer" v-if="!$store.getters.token">
                            <i class="fas fa-sign-in-alt mr-1"></i>
                            <span>Login</span>
                        </div>

                        <span v-else class="flex-end-center">
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
    @import "../assets/styles/custom.less";

    .topbar-content {
        width: @main-content-width;
        padding: @main-padding-vertical;
        position: relative;
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

    .shopping-basket-container {
        position: relative;
        margin-right: 25px;
        opacity: 0.6;
    }

    .shopping-basket {
        font-size: 14pt;
        margin-top: -3px;
    }

    .shopping-basket-container:hover {
        opacity: 1;
    }
</style>