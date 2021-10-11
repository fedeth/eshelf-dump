<script>
import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  mixins: [applicationMixin],
  props: ["product"],
  data: function () {
    return { }
  },
  methods: {
    goToProduct: function(link) {
      if(!window.dataLayer) {
        return window.location.href = link;
      } else {
        window.dataLayer.push({
          'event': 'productClick', 
          'ecommerce': {
            'click': {
              'actionField': {'list': 'Search Results'}, 
              'products': [{
                'name': this.product.title,
                'id': this.product.id,
                'price': (this.product.price / 100),
                'brand': this.product.brand,
                'category': this.pageModel.categories[this.product.category_id].title,
              }]
            }
          },
          'eventCallback': function() {
            window.location.href = link;
          }
        });
      }
    }
  },
  computed: {
    category: function() {  
      return this.pageModel.categories[this.product.category_id].title
    },
  },
}
</script>

<template>
  <div class="w-100 product-item-wrapper d-flex flex-column justify-content-between">
    <div class="cursor-pointer" @click="goToProduct(`/products/${product.name}`)">
      <div class="product-item-picture w-100" :style="{'background-image': `url(${product.main_image})`}"></div>
    </div>
    <div class="product-item-brand text-center pt-3"><b>{{product.brand}}</b></div>
    <div class="product-item-model text-center py-3">{{product.title}}</div>
    <div class="product-item-info d-flex justify-content-center pt-3">
      <div class="product-item-price font-weight-bold text-center">£ {{(product.price / 100).toFixed(2)}}</div>
    </div>
  </div>
  
</template>

<style lang="scss" scoped>

  .product-item-picture {
    padding-top: 100%;
    background-position: center;
    background-size: contain;
    background-repeat: no-repeat;
  }

  @include media-breakpoint-down(sm) {
    .product-item-price {
      font-size: .8rem;
    }
  }

</style>