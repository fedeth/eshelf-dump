<script>

import { applicationMixin } from "src/modules/application_mixin.js";
import too_many_items_picture from "src/pictures/too_many_previews.png";

export default {
  props: ['products'],
  mixins: [applicationMixin],
  mounted: function() {
   
  },
  data: function () {
    return {
      too_many_items_picture: too_many_items_picture,
    }
  },
  methods:{
    goToProductPage(productId) {
      return window.location.href = `/shops/my_shop/products/edit/${productId}`;
    }
  },
  computed: {
  }
}
</script>

<template>
  <div class="container-fluid py-4">
    <div class="row">
      <div class="col-12 py-3 d-flex justify-content-between">
        <h2>Products</h2>
        <div v-if="products.length > 0"><a href="/shops/my_shop/products/new" class="btn btn-dark px-4">ADD PRODUCT</a></div>
      </div>
      <div v-if="products.length > 0" class="col-12 py-5 mb-md-5 bg-white box-shadow">
        <div class="table-responsive">
          <table class="table table-striped">
            <thead>
              <tr>
                <th scope="col" class="d-none d-md-table-cell"></th>
                <th scope="col">Model</th>
                <th scope="col">Brand</th>
                <th scope="col">Price</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="product in products" :key="`${product.name}-key`" @click="goToProductPage(product.id)">
                <td class="d-none d-md-table-cell">
                  <div v-if="product.thumbnail" class="product-thumbnail" :style="{'background-image': `url(${product.thumbnail})`}"></div> 
                  <div v-else class="product-thumbnail" :style="{'background-image': `url(${too_many_items_picture})`}"></div>
                </td>
                <td>{{product.title}}</td>
                <td>{{product.brand}}</td>
                <td>£ {{(product.price / 100).toFixed(2)}}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div v-else class="col-12 py-5 mb-md-5 bg-white box-shadow">
        <h3 class="text-center py-3">Add and manage your products</h3>
        <p class="text-center">This is where you’ll add products and manage your pricing.</p>
        <div class="text-center pt-5">
          <a href="/shops/my_shop/products/new" class="btn btn-dark px-4">ADD PRODUCT</a>
        </div>
      </div>
    </div>
  </div>

</template>

<style lang="scss" scoped>
 
 .product-thumbnail {
   width: 4rem;
   height: 4rem;
   background-size: contain;
   background-repeat: no-repeat;
   border-radius: 0.5rem;
   background-position: center;
 }

 .table th {
   border-top: none;
 }

 tbody {

   tr {
     transition: 0.4s all;
     cursor: pointer;
     &:hover {
       background-color: #fcf5ba;
     }
   }
  
   td {
     vertical-align: middle;
   }
 }

</style>
