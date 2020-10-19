<template>
    <div class="recipe">
        <div class="author d-flex justify-content-between">
            <div class="d-flex align-items-center">
                <i class="far fa-user-circle mr-2"></i>
                <span>{{author}}</span>
            </div>

            <span class="pointer d-flex align-items-center" @click="favorite">
                <i v-if="!showFavorite" title="Add to favorites" class="far fa-heart bookmark"></i>
                <i v-else title="Remove from favorites" class="fas fa-heart bookmark"></i>
            </span>
        </div>
        
        <router-link class="clickable" v-bind:to="'/recipes/recipe/' + id">
            <img v-bind:src="imgURL" width="100%">


            
            <div class="recipe-details">
                <div class="d-flex justify-content-between align-items-start">
                    <span class="title">{{title}}</span>

                    <span class="d-flex justify-content-end align-items-center" v-if="numOfRatings > 0">
                        <Stars v-bind:stars="rating" max="5"></Stars>
                        <span class="number-of-ratings muted ml-2">({{numOfRatings}})</span>
                    </span>
                </div>

                <div class="description normalFont">
                    {{description}}
                </div>

                <div class="time normalFont d-flex justify-content-between align-items-center">
                    <span class="font-weight-bold d-flex align-items-center">
                        <i class="fas fa-stopwatch mr-1"></i>
                        <span>{{formattedCookingTime}}</span>
                    </span>
                    <span class="muted">{{timeFromEpoch}}</span>
                </div>
            </div>

            <div class="matching-ingredients normalFont text-center" v-if="matchCount > 0">
                <span>
                    <i class="fas fa-check mr-1"></i>
                    <strong>{{matchCount}}</strong> 
                    <span> matching ingredient{{matchCount > 1 ? 's' : ''}}</span>
                </span>
            </div>
        </router-link>
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
            author: String,
            isFavorite: Boolean,
            fileId: Number,
            fileType: String,
            matchCount: Number,
            numOfIngredients: Number
        },
        
        data() {
            return {
                showFavorite: this.isFavorite
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
            },
            
            timeFromEpoch() {
				let date = new Date(this.created * 1000);

				return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()}`;
			},
        },

        methods: {
            favorite(recipe) {
				this.$store.dispatch('bookmark', {
					id: this.id
				})
				.then((response) => {
					this.showFavorite = response;
					this.$store.commit('setSystemMessage', {
						content: `Recipe ${response ? 'added to' : 'removed from'} favorites.`,
						error: false
					});
				})
				.catch((err) => {
					this.$store.commit('setSystemMessage', {
						content: err,
						error: true
					});
				});
			}
        }
    }
</script>


<style lang="less" scoped>
    @import "../assets/global.less";

	.recipe {
		background-color: @main-color;
		transition: transform .2s;
		box-shadow: 2px 2px 7px rgba(0, 0, 0, 0.2);
		margin-bottom: 32px;
	}

	.recipe:hover {
		transform: scale(1.02);
	}

    .author {
		background-color: @main-background;
		color: @main-color;
		padding: 8px 20px;
		font-size: 12pt;

		i, .bookmark{
			font-size: 14pt;
		}
    }

    a:hover {
        text-decoration: none !important;
    }

    img {
		height: 200px;
		object-fit: cover;
    }
    
    .recipe-details {
        position: relative;
        background-color: white;
        color: @main-background;
        padding: 15px 20px;
        height: 200px;
    }
    
	.title {
		width: calc(100% - 115px);
		//height: 45px;
        overflow : hidden;
        margin-bottom: 10px;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
    }
    
    .number-of-ratings {
        font-size: 11pt;
        margin-bottom: -2px;
    }

    .description {
		font-size: 10pt;
        word-wrap: normal;
		
		margin-bottom: 10px;
		//height: 90px;
		overflow : hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-line-clamp: 3;
		-webkit-box-orient: vertical;
		color: @main-background;
    }

    .time {
		font-size: 10pt;
        color: @main-background;
        position: absolute;
        bottom: 15px;
        left: 0px;
        width: 100%;
        padding-left: 20px;
        padding-right: 20px;
    }

    .matching-ingredients  {
        font-size: 10pt;
        background-color: @main-background;
        color: @main-color;
        padding: 6px 20px;
    }
</style>