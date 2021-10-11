<script>

import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  mounted: function() {
    if(window.dataLayer && this.content.send_analytics){
      let gtmProducts = this.generateGTMProducts(this.content.products);
      window.dataLayer.push({
        'event': 'transaction', 
        'ecommerce': {
          'purchase': {
            'actionField': {
              'id': this.content.order_info.id,
              'revenue': this.total,
              'shipping': 9.90,
            },
            'products': gtmProducts,
          }
        }
      });
    }
    const urlParams = new URLSearchParams(window.location.search);
    const nothx = urlParams.get('completed');
    this.hideThanksMessage = !!nothx;
  },
  data: function () {
    return {
      content: this.vueContent,
      hideThanksMessage: false
    }
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
      return this.content.number_of_shops * (this.pageModel.constants["STANDARD_SHIPPING_COST"] / 100); 
    },
    promocodeDiscount() {
      let promocodeDiscount = 0;
      if(this.content.promocode_info && this.content.promocode_info.value) {
        promocodeDiscount =  this.content.promocode_info.value / 100;
      }
      return promocodeDiscount;
    },
    total() {
      return this.subtotal + this.deliveryCost - this.promocodeDiscount;
    },
    user() {
      return this.pageModel.user_info;
    }
  }
}
</script>

<template>
  <div class="w-100 bg-light-grey">
    <div class="container py-4 py-md-5">
      <div class="row justify-content-center pb-4">
        <div class="col-12 col-sm-10 col-xl-9">
          <order-progress :progress="content.order_info.status"></order-progress>
        </div>
      </div>
      <div class="row bg-white py-4 py-md-5 px-2 px-md-4">
        <div v-if="!hideThanksMessage" class="col-12 pb-3">
          <h3>Thanks for shopping on eShelf</h3>
        </div>
        <div class="col-12 col-md-8">
          <h3 class="pb-4">Order #00{{content.order_info.id}}</h3>
          <p>An email with your receipt has been sent to <b>{{user.email}}</b></p>
          <h5 class="pt-5 pb-3">Purchased items:</h5>
          <div v-for="product in content.products" :key="`product-item-${product.id}`" class="row pb-3">
            <div class="col-3 col-md-2">
              <div class="product-thumbnail w-100" :style="{backgroundImage: `url(${product.thumbnail})`}"></div>
            </div>
            <div class="col-6 col-md-5 d-flex align-items-center">{{product.title}}</div>
            <div class="col-3 d-flex align-items-center">Quantity: {{product.quantity}}</div>
            <div class="col-2 d-none d-md-flex align-items-center">£ {{((product.price * product.quantity) / 100).toFixed(2)}}</div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="row px-3 px-md-4 pt-4 pt-md-0">
            <div class="col-12 p-4 border">
              <h5 class="m-0">Order summary</h5>
              <div class="d-flex justify-content-between pb-2 pt-3">
                <div class="">Items total</div>
                <div class="">£ {{subtotal.toFixed(2)}}</div>
              </div>
              <div class="d-flex justify-content-between pb-2">
                <div class="">
                  <div>Delivery</div>
                  <div class="font-xs text-std-grey">Standard delivery: 3-5 working days.</div>
                </div>
                <div class="">£ {{deliveryCost.toFixed(2)}}</div>
              </div>
              <div v-if="promocodeDiscount != 0" class="d-flex justify-content-between pb-2">
                <div class="text-danger">Discount code</div>
                <div class="text-danger">- £ {{promocodeDiscount.toFixed(2)}}</div>
              </div>
              <div class="d-flex bold-text justify-content-between py-2">
                <div class="">Total</div>
                <div class="">£ {{total.toFixed(2)}}</div>
              </div>
            </div>
            <div class="col-12 mt-4 p-4 border">
              <h5 class="m-0 pb-3">Delivery address</h5>
              <div>{{content.delivery_info.firstName}} {{content.delivery_info.lastName}}</div>
              <div>{{content.delivery_info.addressLine1}}</div>
              <div v-if="content.delivery_info.addressLine2">{{content.delivery_info.addressLine2}}</div>
              <div>{{content.delivery_info.postcode}}</div>
              <div>{{content.delivery_info.phoneNumber}}</div>
            </div>
            <div class="col-12 mt-4 px-0">
              <a href="/search" class="btn btn-dark w-100">Return to shopping</a>
            </div>
            <div class="col-12 pt-4">
              <div class="text-center">Have any questions? Check out our helpful <a href="/faqs">FAQ page</a>.</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .product-thumbnail {
    background-size: contain;
    background-position: center;
    padding-bottom: 100%;
    background-repeat: no-repeat;
  }

</style>
