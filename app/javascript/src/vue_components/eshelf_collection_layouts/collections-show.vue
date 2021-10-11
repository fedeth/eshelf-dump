<script>

import { applicationMixin } from "src/modules/application_mixin.js";
import { commentsMixin } from "src/modules/comments_mixin.js";

export default {
  props: ['vueContent'],
  mixins: [applicationMixin, commentsMixin],
  mounted: function() {
    this.getComments("example_content");
  },
  data: function () {
    return {
      content: this.vueContent,
      commentText: "",
    }
  },
  methods:{
    mayAddComment() {
      this.addComment(this.commentText, "example_content");
    }
  },
  computed: {
    featuredCategoriesNames(){
      const categoryNames = ["wall_art","room_decor","lighting","kitchen_dining","garden_outdoors","gifts"];
      return categoryNames;
    },
    featuredCategories(){
      let categories = {};
      for (let [key, value] of Object.entries(this.pageModel.categories)) {
        if(this.featuredCategoriesNames.indexOf(value.name) > -1) {
          categories[value.name] = value;
        }
      }
      return categories;
    },
  }
}
</script>

<template>
  <div>
    <div class="container">
      <div class="row">
        <div class="col-12 d-lg-flex d-none justify-content-center py-3">
          <ul class="d-flex text-center py-1 px-0 m-0">
            <li v-for="(categoryName) in featuredCategoriesNames" class="d-block px-5" :key="`menu-category-${categoryName}`">
              <a :href="encodeURI(`/search?category_names[]=${featuredCategories[categoryName].name}`)" class="text-black top-category" >
                {{featuredCategories[categoryName].title.charAt(0).toUpperCase() + featuredCategories[categoryName].title.slice(1)}}
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="collection-header w-100 bg-light-grey d-flex align-items-center">
      <div class="container">
        <div class="row">
          <div class="col-12 d-flex justify-content-center flex-column d-flex">
            <h5>LOREM INFO</h5>
            <h1 class="py-1">Collection show all example</h1>
            <div class="avatar-container d-flex">
              <div class="avatar bg-white mr-3"></div>
              <div class="curator d-flex align-items-center justify-content-center">Curator Name</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="container">
      <div class="row">
        <div class="col-12">
          <p class="description m-0 py-5">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eget nisl efficitur, suscipit nibh vehicula, fringilla sem. Curabitur semper fermentum erat, id efficitur erat aliquet eu. Aliquam imperdiet, neque et fermentum tincidunt, neque libero tempus arcu, ac fringilla ipsum ligula ut ligula. Ut dictum est laoreet quam placerat ullamcorper. Aliquam a imperdiet lectus, sed placerat neque. Vestibulum mollis erat ac faucibus porttitor. Aenean quis scelerisque magna, non sodales tellus. Suspendisse bibendum enim vitae tortor posuere, non rhoncus eros eleifend. Phasellus sit amet elit lobortis nulla porttitor dictum sed at erat. Sed at ipsum diam. Integer tincidunt ante sit amet lacus tincidunt tristique. Proin rhoncus leo nec neque mattis dignissim.
          </p>
        </div>
      </div>
      <div class="row">
        <product-item v-for="(product, index) in content.products" :product="product" :key="`example-${index}`" class="col-6 col-md-4 col-lg-3 pb-5 px-4"></product-item>
      </div>
      <div class="row">
        <div class="col-12 give-us-a-feedback pt-4 pb-5">
          <h3>Do you like this collection?</h3>
          <p>Let us know what you think and if you would like to have new social features like comments, likes and votes. Help us to grow!</p>
          <div class="form-group">
            <textarea maxlength="1500" class="form-control" id="giveUsFeedback" rows="4" v-model="commentText"></textarea>
          </div>
          <div class="form-group text-right">
            <button type="button" class="btn btn-dark px-5 w-100-mobile" @click="mayAddComment()">Submit</button>
          </div>
        </div>
      </div>
      <div class="row px-3 d-none d-sm-flex ">
        <div class="col-12 become-a-curator d-flex align-items-center justify-content-center py-4 mb-5">
          <p class="my-2 my-lg-3">If you want to become a curator to create your own product collections, please contact us at <a href="mailto:info@eshelf.co.uk">info@eshelf.co.uk</a>.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

  .top-category {
    &:hover {
      font-weight: bold;
    }
  }

  .avatar {
    height: 56px;
    width: 56px;
    border-radius: 50%;
  }

  .description {
    font-size: 1.25rem;
  }

  .collection-header {
    min-height: 20rem;
  } 

  .become-a-curator {
    background-color: #f5f5f5;
    border-radius: 0.5rem;
  }

  @include media-breakpoint-down(sm) {
    
    .w-100-mobile {
      width: 100%;
    }

  }

</style>
