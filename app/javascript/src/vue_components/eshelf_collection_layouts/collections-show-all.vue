<script>

import { applicationMixin } from "src/modules/application_mixin.js";
import Flickity from 'flickity';

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  mounted: function() {
    Vue.nextTick(() => {
      this.carousel = new Flickity(this.$refs["collection-carousel"], {
        wrapAround: true,
        cellAlign: 'left',
        contain: true,
        groupCells: false,
        pageDots: true
      });
    });
  },
  data: function () {
    return {
      content: this.vueContent,
    }
  },
  methods:{
    fooBarMethod: function() { },
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
    <div class="animated fadeIn slow w-100 bg-hp-grey text-black text-center py-2">Products from the best boutiques in town</div>
    <div class="container pt-4 pt-lg-5 pb-4">
      <div class="row">
        <div class="col-12 d-flex justify-content-center flex-column d-flex">
          <h1>Curator's room</h1>
          <p class="font-md pt-4">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate</p>
        </div>
      </div>
    </div>
    <div class="container d-none d-xl-block pt-3 pb-5">
      <div class="row">
        <div class="tile-responsive px-3 mb-4">
          <collection-tile :content="{}"></collection-tile>
        </div>
        <div class="tile-responsive px-3 mb-4">
          <collection-tile :content="{}"></collection-tile>
        </div>
        <div class="tile-responsive px-3 mb-4">
          <collection-tile :content="{}"></collection-tile>
        </div>
      </div>
    </div>
    <div class="container pb-5 d-block d-xl-none">
      <div class="w-100 collection-carousel" ref="collection-carousel">     
        <div class="tile-responsive mx-2 mx-md-0 px-0 px-md-2 mb-4">
          <collection-tile :content="{}"></collection-tile>
        </div>
        <div class="tile-responsive mx-2 mx-md-0 px-0 px-md-2 mb-4">
          <collection-tile :content="{}"></collection-tile>
        </div>
        <div class="tile-responsive mx-2 mx-md-0 px-0 px-md-2 mb-4">
          <collection-tile :content="{}"></collection-tile>
        </div>
      </div>
    </div>
    <div class="container">
      <div class="row px-3">
        <div class="col-12 become-a-curator d-flex align-items-center justify-content-center py-4 mb-5">
          <p class="my-2 my-lg-3">If you want to become a curator to create your own product collections, please contact us at <a href="mailto:info@eshelf.co.uk">info@eshelf.co.uk</a>.</p>
        </div>
      </div>
    </div>
    <static-newsletter-stripe></static-newsletter-stripe>
  </div>
 
</template>

<style lang="scss">
  
  .flickity-page-dots {
    bottom: -1.25rem;
  }

  .flickity-prev-next-button {
    &.next {
      right: -4rem;
    }

    &.previous {
      left: -4rem;
    }
  }
  
  @include media-breakpoint-down(sm) {
    .flickity-prev-next-button {
      &.next, &.previous {
        display: none;
      }
    }
  }
 
</style>

<style lang="scss" scoped>

  .top-category {
    &:hover {
      font-weight: bold;
    }
  }
 
  .collection-header {
    min-height: 19rem;
  }

  .tile-responsive {
    width: 33.3%;
  }

  .become-a-curator {
    background-color: #f5f5f5;
    border-radius: 0.5rem;
  }

  @include media-breakpoint-down(lg) {
    .tile-responsive {
      width: 50%;
    }
  }

  @include media-breakpoint-down(sm) {
    .tile-responsive {
      width: 100%;
    }
  }

 
</style>
