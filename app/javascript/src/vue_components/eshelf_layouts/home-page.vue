<script>
import { applicationMixin } from "src/modules/application_mixin.js";
import { geolocationMixin } from "src/modules/geolocation_mixin.js";

export default {
  props: {
    'content': {
      type: Object,
    }
  },
  mixins: [applicationMixin, geolocationMixin],
  data() {
    return {}
  },
  methods: { },
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
    <div class="w-100">
      <div class="container p-0">
        <div class="row justify-content-center">
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
      <div class="animated delay-1s fadeIn slow w-100 bg-hp-grey text-black text-center py-2">Products from the best boutiques in town</div>
      <!-- <collections-two-cols-stripe></collections-two-cols-stripe> -->
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-12 col-md-10 pt-5 pb-4">
            <img class="img-fluid d-none d-sm-block" src="~src/pictures/hp_banner.jpg">
            <img class="img-fluid d-block d-sm-none" src="~src/pictures/hp_banner_mobile.jpg">
          </div>
          <div class="col-10 col-md-8 py-4 text-center">
            <h4>Support independent Boutiques</h4>
            <p class="py-3">Most of our boutiques have had their doors shut down for a while, but they are now reopening to offer you some of the finest products on the market. We at eShelf help connecting people with marvellous boutiques offering an unique online shopping experience.</p>
          </div>
        </div>
      </div>
    </div>
    <div class="w-100 bg-light-grey">
     <top-categories></top-categories>
    </div>
    <div class="container py-5">
      <div class="row">
        <div class="col-12">
          <h2>Best seller products</h2>
        </div>
          <product-item v-for="(product, index) in content.sample_products" :product="product" :key="`example-${index}`" class="col-6 col-md-4 col-lg-3 py-5 px-4"></product-item>
      </div>
    </div>
    <static-newsletter-stripe></static-newsletter-stripe>
  </div>
</template>

<style lang="scss" scoped>

  .top-category {
    &:hover {
      font-weight: bold;
    }
  }

  input[type=text] {
    border:none;
    height: 100%;
  }

  .text-sm {
    font-size: 13px;
  }

  .postcode-box {
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
  }

</style>
