<script>
import { applicationMixin } from "src/modules/application_mixin.js";
import { searchMixin } from "src/modules/search_mixin.js";
import { debounce, get, cloneDeep } from "lodash";

export default {
  mixins: [applicationMixin, searchMixin],
  props: {
    'vueContent': {
      type: Object,
    }
  },
  data: function () {
    return {
      content: this.vueContent,
      loading: false,
    }
  },
  watch: {
    searchedProducts: function() {
      this.fireDataLayerImpression();
    }
  },
  mounted: function(){
    this.fireDataLayerImpression();
  },
  computed: {
    numberOfPages() {
      return globalState.pageModel.search_results.number_of_pages;
    },
    searchedProducts(){
      return globalState.pageModel.search_results.products;
    },
    pages() {
      let pages = [this.pageNumber - 2, this.pageNumber - 1, this.pageNumber, this.pageNumber + 1, this.pageNumber + 2];
      if (this.pageNumber === 1) {
        pages.push(4);
      }
      if (this.pageNumber <= 2 ) {
        pages.push(5);
      }
      if (this.pageNumber === this.numberOfPages) {
        pages.unshift(this.numberOfPages - 3);
      }
      if (this.pageNumber >= this.numberOfPages - 1) {
        pages.unshift(this.numberOfPages - 4);
      }
      pages = pages.filter(p => p > 0 && p <= this.numberOfPages);
      return pages;
    },
    pageNumber() {
      return this.searchParams.page_number|| 1
    },
  },
  methods: {
    getCategoryNameToId(categoryNames = []){
      let categoryNamesCopy = cloneDeep(categoryNames);
      let idToCategoryName = {};

      Object.keys(this.pageModel.categories).forEach(categoryId => {
        let elementIndex = categoryNamesCopy.indexOf(this.pageModel.categories[categoryId].name);
        if( elementIndex > -1) {
          categoryNamesCopy.splice(elementIndex, 1);
          idToCategoryName[this.pageModel.categories[categoryId].id] = this.pageModel.categories[categoryId].name;
        }
      });
      return idToCategoryName;
    },
    changePage(p) {
      if (p > 0 && p <= this.numberOfPages) {
        this.searchParams.page_number = p;
        this.getSearchedProducts(true);
      }
    },
    updatePrice(prices) {
      if (!this.searchParams.price_range) {
        Vue.set(this.searchParams, "price_range", []);
      }
      Vue.set(this.searchParams.price_range, 0, prices[0]);
      Vue.set(this.searchParams.price_range, 1, prices[1]);
      this.getSearchedProducts();
    },
    updateCategories(categories){
      Vue.set(this.searchParams, "category_names", categories);
      this.getSearchedProducts();
    },
    updateOrderBy(order) {
      Vue.set(this.searchParams, "sort_by", order);
      this.getSearchedProducts();
    },
    removeCategoryFilter(category) {
      const categories = this.searchParams.category_names.filter(cat => cat != category);
      this.updateCategories(categories);
    },
    clearAllFilters() {
      location.href = "/search";
    },
    fireDataLayerImpression() {
      if(window.dataLayer && this.searchedProducts.length > 0) {
        let gtmImpressionProducts = this.generateGTMImpressionProducts(this.searchedProducts);
        window.dataLayer.push({
          'event': 'Productimpressions', 
          'ecommerce': {
            'currencyCode': 'GBP',
            'impressions': gtmImpressionProducts,
          }
        });
      }
    }
  },
}
</script>

<template>
  <div class="container">
    <div class="row">
      <!-- Desktop filters -->
      <div class="col-3 border-right d-none d-lg-block">
        <div class="row">
          <!-- <div class="col-12 pt-4 pb-3 border-bottom"> -->
            <!-- <h5><i class="fas fa-store pr-2"></i>Store Collection</h5> -->
            <!-- <change-location @position-updated="getSearchedProducts()"></change-location> -->
          <!-- </div> -->
          <div class="col-12 py-4 border-bottom">
            <filter-price ref="filterPrice" v-on:update-price-filter="updatePrice($event)"></filter-price>
          </div>
          <div class="col-12 py-4 border-bottom">
            <filter-categories
              ref="filterCategories"
              :filteringCategories="getCategoryNameToId(searchParams.category_names)"
              v-on:update-categories-filter="updateCategories($event)"
            ></filter-categories>
          </div>
          <div class="col-12 py-4">
            <div class="clear-filters cursor-pointer" @click="clearAllFilters()">Clear all filters</div>
          </div>
        </div>
      </div>
      <!-- Mobile filters -->
      <div class="col-12 d-lg-none py-3">
        <!-- <div class="d-flex justify-content-between py-3"> -->
          <!-- <h5><i class="fas fa-store pr-2"></i><br/>Store Collection</h5> -->
          <!-- <change-location @position-updated="getSearchedProducts()" dropdownMenuPosition="right"></change-location> -->
        <!-- </div> -->
        <div class="row">
          <div class="col-6 text-center pr-2">
            <button class="btn btn-outline-dark w-100 text-center filters-button" data-toggle="collapse" data-target="#filters">Filter</button>
          </div>
          <div class="col-6 text-center pl-2">
            <filter-order-by ref="filterOrderByMobile" v-on:update-order-by-filter="updateOrderBy($event)"></filter-order-by>
          </div>
        </div>
        <div class="collapse" id="filters">
          <div class="row mx-0 mt-3">
            <div class="col-12 py-3 border-bottom">
              <filter-price ref="filterPriceMobile" v-on:update-price-filter="updatePrice($event)"></filter-price>
            </div>
            <div class="col-12 py-3 border-bottom">
              <filter-categories
                ref="filterCategoriesMobile"
                :filteringCategories="getCategoryNameToId(searchParams.category_names)"
                v-on:update-categories-filter="updateCategories($event)"
              ></filter-categories>
            </div>
            <div class="col-12 py-3 border-bottom text-center">
              <div class="clear-filters cursor-pointer" @click="clearAllFilters()">Clear all filters</div>
            </div>

          </div>
        </div>
      </div>
      <!-- Results section -->
      <div class="col-12 col-lg-9 py-3">
        <div class="row d-none d-lg-flex">
          <div class="col pr-1">
          </div>
          <div class="col-auto d-flex align-items-center">
            <filter-order-by ref="filterOrderBy" v-on:update-order-by-filter="updateOrderBy($event)"></filter-order-by>
          </div>
        </div>
        <div class="row py-lg-3" v-if="searchParams.categoryFilters">
          <div class="col-12 d-flex flex-wrap mx-n2 mt-n2">
            <span
              class="btn btn-sm btn-outline-dark px-3 py-2 mx-2 mt-2 font-weight-normal"
              v-for="(category, categoryIndex) in searchParams.categoryFilters"
              :key="`category-${categoryIndex}-${category}`"
            >
              {{pageModel.categories[category].title}}
              <i class="fas fa-times cursor-pointer ml-2" @click="removeCategoryFilter(category)"></i>
            </span>
          </div>
        </div>
        <div class="row position-relative">
          <loading-spinner v-if="loading"></loading-spinner>
          <product-item
            v-for="(product, index) in searchedProducts"
            :key="`product-${product.name}-${index}`"
            :product="product"
            class="col-6 col-lg-4 py-3"
          ></product-item>
          <div class="col-12">
            <div v-if="!!searchedProducts && !loading" class="results-container my-5">
              <div v-if="searchedProducts.length == 0 && !loading">
                <p class="text-danger mb-0">We are sorry, no product found in selected category</p>
              </div>
              <div class="d-flex justify-content-center mt-5" v-if="!!numberOfPages && numberOfPages > 1">
                <ul class="pagination">
                  <li class="page-item" :class="{'disabled': pageNumber === 1}">
                    <a class="page-link" href="#" @click="changePage(pageNumber - 1)">
                      Previous
                    </a>
                  </li>
                  <li class="page-item" v-for="(p, pIndex) in pages" :key="`page-index-${pIndex}`" :class="{'active': p === pageNumber}">
                    <a class="page-link" href="#" @click="changePage(p)">{{p}}</a>
                  </li>
                  <li class="page-item" :class="{'disabled': pageNumber === numberOfPages}">
                    <a class="page-link" href="#" @click="changePage(pageNumber + 1)">
                      Next
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>             
    </div>

  </div>
</template>

<style lang="scss" scoped>

  .page-link {
    color: $dark;
    &:hover {
      background-color: $dark;
      color: white;;
    }
  }

  .page-item.active .page-link {
    background-color: $dark;
    border-color: #dee2e6;
    color: white;
  }

  .cursor-pointer {
    cursor: pointer;
  }

  .clear-filters {
    text-decoration: underline;
  }

  .modal {
    padding-left: 0px !important;
  }
  
  .modal-dialog {
    max-width: 1000px;

    @include media-breakpoint-down(md) {
      margin: 1rem;
    }
  }
</style>