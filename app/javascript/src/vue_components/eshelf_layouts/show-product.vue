<script>

import { applicationMixin } from "src/modules/application_mixin.js";
import { Datetime } from 'vue-datetime';
import { cloneDeep } from 'lodash';
import 'vue-datetime/dist/vue-datetime.css'

export default {
  props: ['content'],
  mixins: [applicationMixin],
  // components: { datetime: Datetime },
  mounted: function() {
    if(window.dataLayer){
      window.dataLayer.push({
        'event': 'productDetails', 
        'ecommerce': {  
          'products': [{
            'name': this.content.product.title,
            'id': this.content.product.id,
            'price': (this.content.product.price / 100),
            'brand': this.content.product.brand,
            'category': this.pageModel.categories[this.product.category_id].title,
          }]
        }
      });
    }
  },
  data: function () {
    return {
      orderQuantity: 1,
    };
  },
  methods:{
    addProductToBasket() {
      ApplicationModule.ajaxGet({
        url: "/api/v1/virtual_baskets/add_product",
        data: {id: this.product.id, quantity: this.orderQuantity},
        success: (data) => {
          if(data.status == "ok"){
            if(!window.dataLayer) {
              return window.location.href ="/shopping_cart";
            } else {
              window.dataLayer.push({
                'event': 'addToCart',
                'ecommerce': {
                  'currencyCode': 'GBP',
                  'add': {
                    'products': [{
                      'name': this.product.title,
                      'id': this.product.id,
                      'price': (this.product.price / 100),
                      'brand': this.product.brand,
                      'category': this.pageModel.categories[this.product.category_id].title,
                      'quantity': this.orderQuantity
                    }]
                  }
                },
                'eventCallback': function() {
                  window.location.href ="/shopping_cart";
                }
              })
            }
          }
        },
        error: (err) => {
          console.log(err);
        }
      });
    },
  },
  computed: {
    product: function(){
      return this.content.product;
    },
    productPrice: function() {
      return this.product.price / 100;
    },
  }
}
</script>

<template>
  <div>
    <div class="container">
      <div class="row py-3 py-md-5 justify-content-center">
        <div class="col-12 col-md-5 col-xl-4 pr-md-5"> 
          <div class="product-img" :style="{'background-image': `url(${product.main_image})`}"></div>
        </div>
        <div class="col-12 col-md-7 col-xl-4">
          <div class="row">
            <div class="col-12 pt-3">
              <p>{{product.brand}}</p>
            </div>
            <div class="col-12 pb-3">
              <h3>{{product.title}}</h3>
            </div>
            <div class="col-12">
              <p>£{{productPrice}}</p>
            </div>
            <div class="col-12 pb-3">
              <label class="mb-0 quantity">Quantity:</label>
              <div class="input-group mb-3 d-flex align-items-center">
                <select class="select bg-light-grey" id="inputGroupSelect02" v-model="orderQuantity" :disabled="product.quantity < 1" >
                  <option 
                    v-for="i in product.quantity"
                    :key="`quantity-${i}`"
                    :selected="i == 1"
                  >
                    {{i}}
                  </option>
                </select>
                <div v-if="product.quantity > 0" class="pl-3 text-green">In stock</div>
                <div v-else class="pl-3 text-danger">Out of stock</div>
              </div>
            </div>
          </div>
          <div class="btn btn-dark px-4" @click="addProductToBasket()">Add to basket</div>
        </div>
      </div>
      <div class="row">
        <div class="col-12 py-3"></div>
      </div>
    </div>
    <div class="w-100 bg-light-grey">
      <div class="container py-5">
        <div class="row justify-content-center">
          <div class="col-12 col-xl-8 text-dark-grey">
            <h6 class="pb-3">Product details:</h6>
            <p>{{product.description}}</p>
          </div>
        </div>
        <div v-if="product.tech_spec" class="row justify-content-center py-3">
          <div class="col-12 col-xl-8 text-dark-grey">
            <h6 class="pb-3">More details:</h6>
            <ul class="m-0">
              <li v-for="(spec, index) in product.tech_spec" :key="`spech-${index}`">{{spec}}</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div> 

</template>

<style lang="scss" scoped>
  .quantity {
    font-size: 0.85rem;
  }

  .select {
    min-width: 50px;
  }

  .tab-content{
    box-shadow: 3px 5px 6px #ddd;
  }

  .disclaimer {
    font-size: 13px;
  }

  .product-img {
    padding-top: 100%;
    background-size: contain;
    background-position: center;
    background-repeat: no-repeat;  }
</style>
