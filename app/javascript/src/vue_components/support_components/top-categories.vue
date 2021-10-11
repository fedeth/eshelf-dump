<script>

import { applicationMixin } from "src/modules/application_mixin.js";
import Flickity from 'flickity';

export default {
  // props: ['prop1'],
  mixins: [applicationMixin],
  mounted: function() {
    Vue.nextTick(() => {
      this.carousel = new Flickity(this.$refs["category-carousel"], {
        wrapAround: false,
        cellAlign: 'left',
        contain: true,
        groupCells: false,
        pageDots: false
      });
    });
  },
  data: function () {
    return {
      carousel: null,
    }
  },
  methods:{},
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
  <div class="container py-5" top-categories>
    <div class="row">
      <div class="col-12">
        <h2>Our categories</h2>
      </div>
      <div class="col-12">
        <div class="pt-5" ref="category-carousel">
          <a v-for="categoryName in featuredCategoriesNames" :key="categoryName" class="category-box px-2 text-black" :href="encodeURI(`/search?category_names[]=${featuredCategories[categoryName].name}`)" >
            <div class="category-img bg-hp-grey" :style="{backgroundImage: `url(${featuredCategories[categoryName].category_image})`}"></div>
            <div class="category-name text-center bg-white py-3">{{featuredCategories[categoryName].title.charAt(0).toUpperCase() + featuredCategories[categoryName].title.slice(1)}}</div>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" >
  [top-categories] {

    .flickity-prev-next-button.previous {
      left: -3.5rem;
    }

    .flickity-prev-next-button.next {
      right: -3.5rem;
    }

    .category-box {
      width: 20%;
      min-height: 200px;
      .category-img {
        padding-top: 85%;
        background-position: center;
        background-size: cover;
      }
    }

    @include media-breakpoint-down(lg){
      .category-box {
          width: 25%;
      } 
    }

    @include media-breakpoint-down(md){
      .category-box {
          width: 33.3%;
      } 
    }

    @include media-breakpoint-down(sm){
      .category-box {
          width: 50%;
      }
      .flickity-prev-next-button {
        display: none;
      }

    }
}
</style>
