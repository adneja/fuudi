<template>
    <div class="recipe card-inverted" :class="{'no-matches':  $store.getters.ingredients.length > 0 && matchCount === 0}">
        <div class="colors-main font-normal font-m py-1 text-center" v-if="$store.getters.ingredients.length > 0">
            <span>
                <strong>{{matchCount}}</strong> 
                <span> matching ingredient{{matchCount > 1 || matchCount === 0 ? 's' : ''}}</span>
            </span>
        </div>
        
        <router-link :title="title" class="cursor-pointer cursor-underline" :to="`/recipes/recipe/${id}`">
            <img :src="imgURL" width="100%">
        </router-link>

        <div class="relative recipe-details colors-inverted p-3">
            <div class="flex-between-start">
                <div class="title">
                    <router-link :title="title" class="cursor-pointer cursor-underline" :to="`/recipes/recipe/${id}`">
                        <div class="font-l">{{title}}</div>
                    </router-link>

                    <router-link :title="createdByName" class="cursor-pointer cursor-underline" :to="`/user/${createdBy}`">
                        <div class="font-s font-faded mb-2">by {{createdByName}}</div>
                    </router-link>
                </div>
                
                <router-link class="cursor-pointer cursor-underline" :to="`/recipes/recipe/${id}?scrollToRatings=true`">
                    <span class="flex-end-center">
                        <Stars :stars="rating" max="5"></Stars>
                        <span class="font-s font-normal font-faded ml-1">({{numOfRatings}})</span>
                    </span>
                </router-link>
            </div>

            <div class="description font-italic font-normal font-s mb-2">
                {{description}}
            </div>

            <div class="absolute-bottom-left p-3 font-normal flex-between-center w-100">
                <span class="font-bold font-s flex-start-center">
                    <i class="fas fa-stopwatch mr-1"></i>
                    <span class="time">{{formattedCookingTime}}</span>
                </span>
            </div>
        </div>
    </div>
</template>

<script>
    import Stars from '../components/Stars.vue';

    export default {
        name: 'recipe',

        props: {
            id: Number,
            title: String,
            description: String,
            cookingTime: Number,
            rating: Number,
            numOfRatings: Number,
            created: Number,
            createdBy: Number,
            createdByName: String,
            isFavorite: Boolean,
            fileId: Number,
            fileType: String,
            matchCount: Number,
            numOfIngredients: Number
        },
        
        data() {
            return {
                showFavorite: this.isFavorite,
                loadingFavorite: false
            }
        },

        components: {Stars},

        computed: {
            imgURL() {
                return `${process.env.VUE_APP_REST_ADDR}/api/files/img/${this.fileId}.${this.fileType.split('/')[1]}`;
            },

            formattedCookingTime() {
				let hours = Math.floor(this.cookingTime / 60),
					minutes = this.cookingTime - (hours * 60);

				if(hours) {
					return `${hours}h ${minutes > 0 ? minutes + 'm' : ''}`;
				} else {
					return `${minutes}m`;
				}
            }
        },

        methods: {
            toggleFavorite() {
                let action = this.showFavorite? 'usersRecipesDelete' : 'usersRecipesInsert';

                this.loadingFavorite = true;
                this.$store.dispatch(action, {
                    recipeId: this.id
                })
                .then((response) => {
                    this.showFavorite = response[0].is_favorite;
                })
                .catch((err) => {
                    this.$store.commit('setSystemMessage', {
                        content: err,
                        error: true
                    });
                })
                .finally(() => {
                    this.loadingFavorite = false;
                });
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../assets/styles/custom.less";

    img {
        height: 200px;
        width: 100%;
		object-fit: cover;
    }

    .recipe-details {
        height: 200px;
    }

    .title {
		width: calc(100% - 115px);
        overflow : hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
    }

    .description {
        word-wrap: normal;
		overflow : hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 3;
		-webkit-box-orient: vertical;
    }

    .time {
        transform: translateY(1px);
    }

    .no-matches {
        opacity: 0.6;
    }
</style>