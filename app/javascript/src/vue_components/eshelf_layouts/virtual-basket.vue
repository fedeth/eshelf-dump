<script>

import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  data: function () {
    return {
      content: this.vueContent,
    }
  },
  methods:{
    goToCheckout(){
      if(this.pageModel.user_info.id) {
        window.location = "/order/new/delivery_details";
      } else {
        window.location = "/users/sign_up";
      }
    },
    removeProduct: function(product) {
      ApplicationModule.ajaxGet({
        url: "/api/v1/virtual_baskets/remove_product",
        data: {id: product.id},
        success: (data) => {
          if(data.status == "ok"){
            if(!window.dataLayer) {
              return window.location.reload();
            } else {
              window.dataLayer.push({
                'event': 'removeFromCart',
                'ecommerce': {
                  'remove': {
                    'products': [{
                      'name': product.title,
                      'id': product.id,
                      'price': (product.price / 100),
                      'brand': product.brand,
                      'category': this.pageModel.categories[product.category_id].title,
                      'quantity': product.quantity
                    }]
                  }
                },
                'eventCallback': function() {
                  window.location.reload();
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
    subtotal(){
      let price = 0;
      if(this.content.products) {
        price = this.content.products.reduce((totalPrice, product) => (totalPrice += (product.price * product.quantity)), 0);
      }
      return (price / 100);
    },
    deliveryCost() {
      if(this.content.number_of_shops) {
        return this.content.number_of_shops * (this.pageModel.constants["STANDARD_SHIPPING_COST"] / 100); 
      } else {
        return 0;
      }
    },
    total() {
      return this.subtotal + this.deliveryCost;
    },
  }
}
</script>

<template>
  <div class="container">
    <div class="row pb-5">
      <div class="col-12 py-4 px-2 px-md-0"><h1>Basket</h1></div>
      <div class="col-12 col-md-8">
        <div class="row pr-2 pl-2 pl-md-0 pr-md-4">
          <div v-if="!content.products">Your basket is empty.</div>
          <div v-for="product in content.products" :key="`basket-product-${product.id}`" class="col-12 border mb-4">
            <div class="row position-relative">
              <div class="remove-product-box position-absolute text-std-grey" @click="removeProduct(product)">
                <i class="far fa-times-circle"></i>
              </div>
              <div class="col-2 p-2">
                <div class="product-thumbnail w-100" :style="{backgroundImage: `url(${product.thumbnail})`}"></div>
              </div>
              <div class="col-6 col-md-5 d-flex justify-content-center align-items-start flex-column">
                <div class="py-2 bold-text">{{product.brand}}</div>
                <div class="py-2">{{product.title}}</div>
              </div>
              <div class="col-2 d-none d-md-flex justify-content-center align-items-start flex-column">
                <div class="py-2 bold-text">£ {{(product.price / 100).toFixed(2)}}</div>
                <div class="py-2 font-xs">(VAT included)</div>
              </div>
              <div class="col-4 col-md-3 d-flex justify-content-center align-items-start flex-column">
                <div class="py-2 font-sm">Quantity: <span class="bold-text">{{product.quantity}}</span></div>
                <div class="py-2 font-sm">£ {{((product.price * product.quantity) / 100).toFixed(2)}}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-4">
        <div class="row border sticky-top py-4 px-3 mb-md-4">
          <div class="col-12 d-flex pb-3">
            <div class="bold-text">Total</div>
          </div>
          <div class="col-12 d-flex justify-content-between py-2">
            <div class="">Sub total</div>
            <div class="">£ {{subtotal.toFixed(2)}}</div>
          </div>
          <div class="col-12 d-flex justify-content-between py-2 border-bottom">
            <div class="">Delivery</div>
            <div class="">£ {{deliveryCost.toFixed(2)}}</div>
          </div>
          <div class="col-12 d-flex justify-content-between pb-2 pt-3">
            <div class=" bold-text">Total</div>
            <div class="d-flex flex-column">
              <div class="bold-text text-right">£ {{total.toFixed(2)}}</div>
              <div class="font-xs text-right text-std-grey">VAT included</div>
            </div>
          </div>
          <div class="col-12 text-right pt-4">
            <button type="button" class="btn btn-dark w-100" :disabled="(total < 1)" @click="goToCheckout()">Checkout</button>
            <!-- <div class="font-sm text-std-grey pt-3 text-center">FREE DELIVERY only for orders over 99.00£</div> -->
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

  .remove-product-box {
    z-index: 2;
    top: 0.2rem;
    right: 0.4rem;
    font-size: 1rem;
    
    i {
      cursor: pointer;
      &:hover {
        color: $black;
      }
    }
  }

  .sticky-top {
    top: 2rem;
  }

  .product-thumbnail {
    background-size: contain;
    background-position: center;
    padding-bottom: 100%;
    background-repeat: no-repeat;
  }

</style>
