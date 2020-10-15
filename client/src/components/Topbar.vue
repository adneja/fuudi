<template>
    <div class="topbar d-flex justify-content-center">
        <div class="topbar-content">
            <div class="d-flex justify-content-between align-items-center">
                <div class="left d-flex justify-content-start align-items-center">
                    <!-- Logo -->
                    <div class="logo">
                        <router-link to="/" title="Home" class="d-flex justify-content-start align-items-center">
                            <i class="fas fa-hamburger mr-1"></i>
                            <span>Fuudhub</span>
                        </router-link>
                    </div>

                    <div class="location d-md-none d-block">
                        <i class="fas fa-angle-right mx-2"></i>
                        <span>{{$route.name}}</span>
                    </div>

                    <!-- Desktop menu items -->
                    <div class="ml-4 d-md-block d-none">
                        <router-link to="/recipes" title="Browse all recipes" class="menu-item-desktop mr-3">
                            <span>Recipes</span>
                        </router-link>

                        <router-link to="/plans" title="My meal plans" class="menu-item-desktop mr-3">
                            <span>Plans</span>
                        </router-link>

                        <router-link to="/ratings" title="My meal plans" class="menu-item-desktop mr-3">
                            <span>Ratings</span>
                        </router-link>
                    </div>
                </div>
                
                <!-- Right side of navbar -->
                <div class="right">
                    <div class="d-md-flex  d-none justify-content-end align-items-center">
                        <div v-on:click="showLogin" title="Log in" class="menu-item-desktop pointer mr-3" v-if="!$store.getters.token">
                            <i class="fas fa-sign-in-alt mr-1"></i>
                            <span>Login</span>
                        </div>

                        <span v-else class="d-flex justify-content-end align-items-center">
                            <span v-on:click="$store.commit('setShowUserMenu', true)" class="name pointer d-flex justify-content-start align-items-center">
                                <span>{{$store.getters.userData.name}}</span>
                            </span>

                            <span class="menu-item-desktop ml-3 pointer" title="Log out" v-on:click="logout">
                                <i class="fas fa-sign-out-alt"></i>
                            </span>
                        </span>
                    </div>

                    <!-- Mobile menu button-->
                    <div class="d-md-none d-flex justify-content-end align-items-center">
                        <i v-on:click="$store.commit('setShowMobileMenu', true)" class="fas fa-bars menu-button"></i>
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
        box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
    }

    .topbar-content {
        width: @main-content-width;
        padding: @main-padding-vertical @main-padding-horizontal;
        position: relative;
    }

    .arrow {
        z-index: 99;
    } 

    .profile-img {
        font-size: 16pt;
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
        font-size: 13pt;
        opacity: 0.6;
    }

    .name {
        font-size: 13pt;
    }

    .router-link-active {
        opacity: 1 !important;
    }

    .menu-item-desktop:hover {
        opacity: 1;
    }
</style>