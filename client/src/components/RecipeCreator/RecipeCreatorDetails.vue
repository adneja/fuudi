<template>
    <div>
        <div class="card-inverted">
            <div class="container-fluid font-m">
                <div class="row">
                    <div class="col-md-6 px-0 colors-main flex-center-center">
                        <div v-if="!fileId" class="text-center cursor-pointer py-3" @click="chooseFile">
                            <i class="fas fa-upload image"></i>
                            <div class="font-l mt-2">Upload image</div>
                        </div>

                        <div v-else>
                            <img class="recipe-image" ref="img" width="100%" v-bind:src="uploadedFilePath">
                            <div>
                                <button @click="chooseFile" class="btn btn-primary w-100">
                                    <i class="fas fa-upload mr-2"></i>
                                    <span>Change</span>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 p-md-4 p-3">
                        <div class="row">
                            <div class="col-12 mb-4">
                                <div>Title</div>
                                <input v-model="title" type="text" class="form-control input-border">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12 mb-4">
                                <div>Description</div>
                                <textarea v-model="description" class="form-control input-border" rows="3"></textarea>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 pb-md-0 pb-4">
                                <div>Cooking Time</div>
                                <input v-model="cookingTime" type="number" class="form-control input-border">
                            </div>
                            <div class="col-md-6">
                                <div>Portions</div>
                                <input v-model="portions" type="number" class="form-control input-border">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <input 
            @change="handleFileChange" 
            accept="image/*" 
            class="file invisible fixed-bottom-right" 
            ref="file" 
            type="file"
            name="recipe">
    </div>
</template>

<script>
    export default {
        name: 'recipecreatordetails',

        data() {
            return {
                fileId: null,
                title: '',
                description: '',
                cookingTime: null,
                portions: null,
                uploadedFile: null
            }
        },

        computed: {
            uploadedFilePath() {
				return `${process.env.VUE_APP_REST_ADDR}/api/files/img/${this.uploadedFile}`;
			}
        },

        methods: {
            chooseFile() {
                this.$refs.file.value = "";
                this.$refs.file.click();
			},
			
			handleFileChange() {
				let file = this.$refs.file.files[0],
					formData = new FormData();

				formData.append('file', file);
				this.uploadingFile = true;

				this.$store.dispatch('filesUpload', formData)
				.then((response) => {
					this.uploadedFile = response.path;
					this.fileId = response.id;

					this.$store.commit('setSystemMessage', {
						content: 'File uploaded!',
						error: false
					});
				})
				.catch((err) => {
					this.$store.commit('setSystemMessage', {
						content: err,
						error: true
					});
				})
				.finally(() => {
					this.uploadingFile = false;
				});
            },
            
            getDetails() {
                return {
                    fileId: this.fileId,
                    title: this.title,
                    description: this.description,
                    cookingTime: this.cookingTime,
                    portions: this.portions
                };
            },

			removeFile() {
				this.fileId = null;
				this.uploadedFile = null;
			}
        }
    }
</script>

<style lang="less" scoped>
    @import "../../assets/styles/custom.less";

    .image {
        font-size: 40pt;
    }

    .file {
		height: 0px;
		width: 0px;
    }
    
    img {
		width: 100%;
		height: auto;
	}
</style>