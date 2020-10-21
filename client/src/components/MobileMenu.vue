<template>
    <div class="mobilemenu">
        <div class="mobilemenu-panel">
            <!-- Title -->
            <div class="title d-flex justify-content-between align-items-center mb-3">
                <div>Menu</div>

                <button class="btn textButton" @click="close">
                    <i class="fas fa-times closeButton"></i>
                </button>
            </div>

            <div class="mb-2">
                <router-link to="/recipes" class="menu-item ">
                    Recipes
                </router-link>
            </div>

            <div class="mb-2">
                <router-link to="/plans" class="menu-item ">
                    Plans
                </router-link>
            </div>

            <hr class="my-4">

            <div class="mt-4">
                <div v-if="!$store.getters.token">
                    <div title="Login" class="menu-item" @click="showLogin">Login</div>
                </div>

                <div v-else>
                    <div class="name mb-3">{{$store.getters.userData.name}}</div>

                    <div class="mb-2">
                        <router-link to="/cookbook" class="menu-item">
                            My cookbook
                        </router-link>
                    </div>

                    <div class="mb-2">
                        <router-link to="/shoppinglist" class="menu-item">
                            Shopping list
                        </router-link>
                    </div>

                    <div class="mb-2">
                        <router-link to="/createrecipe" class="menu-item">
                            Create recipe
                        </router-link>
                    </div>

                    <div class="mb-2">
                        <router-link to="/settings" class="menu-item">
                            Settings
                        </router-link>
                    </div>

                    <div title="Log out" class="menu-item" @click="logOut">Log out</div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        name: 'MobileMenu',

        methods: {
            close() {
                this.$store.commit('setShowMobileMenu', false);
            },
            
            showLogin() {
                this.$store.commit('setShowLoginSidebar', true)
                this.close();
            },

            logOut() {
                this.close();
                
                this.$store.dispatch('logout', this.$route)
                .then((response) => {
                    if(response) {
                        this.$router.push({name: 'Home'});
                    }
                });
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/global.less";

    .mobilemenu {
        position: fixed;
        top: 0px;
        right: 0px;
        height: 100vh;
        width: 100vw;
        z-index: 999999;
    }

    .mobilemenu-panel {
        position: absolute;
        top: 0px;
        right: 0px;
        height: 100vh;
        width: 100%;
        max-width: 430px;
        background-color: @main-background;
        box-shadow: 0px 0px 6px rgba(0, 0, 0, 0.3);
        z-index: 9999999;
        padding: 40px;
    }

    .title {
        font-size: 20pt;
        color: @main-color;

        button {
            width: 31px;
        }
    }

    .menu-item{
        color: @main-color !important;
        margin-bottom: 8px;
        font-size: 18pt;
        opacity: 0.7;
    }

    .menu-item:hover {
        opacity: 1;
    }

    .closeButton {
        font-size: 20pt;
    }

    .name {
        color: @main-color !important;
        margin-bottom: 8px;
        font-size: 20pt;
    }

    a:hover {
        text-decoration: none;
    }

    .router-link-active {
        opacity: 1;
    }
</style>