<template>
    <div class="filtercookingtime">
        <div class="flex-between-center font-l">
            <div>Cooking time</div>
            <div class="ml-1 font-normal font-m font-bold">
                <span>{{formattedCookingTime}}</span>
                <span v-if="cookingTime == max">+</span>
            </div>
        </div>
        <input class="w-100" type="range" :min="min" :max="max" v-model="cookingTime">
    </div>  
</template>

<script>
    export default {
        name: 'filtercookingtime',

        props: {
            min: Number,
            max: Number
        },

        data() {
            return {
                cookingTime: this.$store.getters.cookingTime || this.max
            }
        },

        computed: {
            formattedCookingTime() {
				let hours = Math.floor(this.cookingTime / 60),
					minutes = this.cookingTime - (hours * 60);

				if(hours) {
					return `${hours}h ${minutes > 0 ? minutes + 'm' : ''}`;
				} else {
					return `${minutes}m`;
				}
            },
        },

        watch: {
            cookingTime(newValue, oldValue) {
                this.$store.commit('setCookingTime', newValue);
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";
</style>