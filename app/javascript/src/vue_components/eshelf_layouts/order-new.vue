<script>

import { applicationMixin } from "src/modules/application_mixin.js";
// import { fooBar } from 'lodash';

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  mounted: function() {
    Vue.nextTick(() => {
      $("#collapseItem").on('show.bs.collapse', function () {
        let arrow = document.getElementById("arrow");
        arrow.classList.add("rotate180");
      });
      $("#collapseItem").on('hide.bs.collapse', function () {
        let arrow = document.getElementById("arrow");
        arrow.classList.remove("rotate180");
      });
    });
    if(window.dataLayer){
      let gtmProducts = this.generateGTMProducts(this.content.products);
      window.dataLayer.push({
        'event': 'checkout_option', 
        'ecommerce': {
          'checkout': {
            'actionField': {
              'step': 1
            },
            'products': gtmProducts,
          }
        }
      });
    }
  },
  data: function () {
    return {
      content: this.vueContent,
      inProgress: false,
      promocode: {
        name: null,
        value: null,
        isValid: false,
        errors: []
      },
      deliveryInfo: {
        firstName: null,
        lastName: null,
        addressLine1: null,
        addressLine2: null,
        postcode: null,
        phoneNumber: null,
        notes: null,
      }
    }
  },
  methods:{
    submitOrder: function() {
      this.inProgress = true;
      ApplicationModule.postDataForm({
        url: "/api/v1/order/create",
        data: {delivery_info: this.deliveryInfo, promocode: this.promocode.name},
        success: (data) => {
          if(data) {
            window.location.replace(`/order/${data.order_id}/payment`);
          }
        }
      });
    },
    removePromocode: function() {
      this.promocode.name = null;
      this.promocode.value = null;
      this.promocode.isValid = false;
    },
    checkPromocode: function() {
      ApplicationModule.post({
        url: "/api/v1/promocode/check_code",
        data: {promocode: this.promocode.name},
        success: (data) => {
          console.log("promocode", data);
          if(data.errors.length > 0) {
            Vue.set(this.promocode, "errors", data.errors);
          } else {
            Vue.set(this.promocode, "errors", []);
            this.promocode.isValid = true;
            this.promocode.value = data.value;
          }
        }
      })
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
      return this.promocode.value ? this.promocode.value / 100 : 0;
    },
    total() {
      return this.subtotal + this.deliveryCost - this.promocodeDiscount;
    },
  }
}
</script>

<template>
  <div class="w-100 bg-light-grey">
    <div class="container py-3 py-md-5">
      <div class="row justify-content-center pb-4">
        <div class="col-12 col-sm-10 col-xl-9">
          <order-progress :progress="null"></order-progress>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-md-8 p-3 p-md-5 order-2 order-md-1 bg-white">
          <h2 class="pb-4">Delivery address</h2>
          <form @submit.stop.prevent="submitOrder()">
            <div class="form-row">
              <div class="form-group col-6 pr-3">
                <label for="name">First name:</label>
                <input type="text" v-model="deliveryInfo.firstName" class="form-control" id="firstName" required>
              </div>
              <div class="form-group col-6">
                <label for="name">Last name:</label>
                <input type="text" v-model="deliveryInfo.lastName" class="form-control" id="lastName" required>
              </div>
              <div class="form-group col-12">
                <label for="name">Line address 1:</label>
                <input type="text" v-model="deliveryInfo.addressLine1" class="form-control" id="addressLine1" required>
              </div>
              <div class="form-group col-12">
                <label for="name">Line address 2:</label>
                <input type="text" v-model="deliveryInfo.addressLine2" class="form-control" id="addressLine2">
              </div>
              <div class="form-group col-6 pr-3">
                <label for="name">Postcode:</label>
                <input type="text" v-model="deliveryInfo.postcode" class="form-control" id="postcode" pattern="((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})" required>
              </div>
              <div class="form-group col-6">
                <label for="phone-number">Phone number:</label>
                <div class="input-group">
                  <div class="input-group-prepend">
                    <span class="input-group-text">+44</span>
                  </div>
                  <input type="tel" v-model="deliveryInfo.phoneNumber" class="form-control" id="phone-number" pattern="^[0-9]{6,}$" required>
                </div>
              </div>
              <div class="form-group col-12">
                <label for="products">Additional info:</label>
                <textarea class="form-control" v-model="deliveryInfo.notes" id="noted"></textarea>
              </div>
            </div>
            <div class="pt-3 pt-sm-4">
              <button type="submit" :disabled="inProgress" class="btn btn-dark buy-btn w-100">Continue</button>
            </div>
          </form>
        </div>
        <div class="col-12 col-md-4 order-1 order-md-2">
          <div class="row pl-md-4 h-100">
            <div class="col-12 d-flex flex-column justify-content-between md-4 bg-white">
              <div class="upper-section pb-4">
                <h5 class="text-center py-4">Summary</h5>
                <div class="product-preview d-flex flex-column px-3">
                  <div v-for="product in content.products" :key="`product-${product.id}`" class="row pb-3">
                    <div class="col-3">
                      <div class="product-thumbnail w-100" :style="{backgroundImage: `url(${product.thumbnail})`}"></div>
                    </div>
                    <div class="col-5 d-flex align-items-center">Quantity: {{product.quantity}}</div>
                    <div class="col-4 d-flex align-items-center">£ {{(product.price / 100).toFixed(2)}}</div>
                  </div>
                </div>
              </div>
              <div class="lower-section">
                <div class="">
                  <div class="" id="heading">
                    <a class="btn w-100 text-left position-relative px-0" role="button" data-toggle="collapse" data-target="#collapseItem" aria-expanded="true" aria-controls="collapse">
                      <div class="arrow position-absolute d-flex align-items-center h-100"><i id="arrow" class="fas fa-chevron-down"></i></div>
                      <div class="underline-text">Do you have a Discount Code?</div>
                    </a>
                  </div>
                  <div id="collapseItem" class="collapse" aria-labelledby="heading">
                    <div class="">
                       <form id="promocodeForm" class="d-flex py-2" @submit.prevent="checkPromocode()">
                         <input v-model="promocode.name" class="form-control" type="text" :disabled="promocode.isValid" required>
                         <button v-if="!promocode.isValid" type="submit" :disabled="!promocode.name" class="btn btn-dark ml-1 btn-mw">APPLY</button>
                         <button v-else class="btn btn-dark ml-1 btn-mw" type="button" @click.prevent="removePromocode()" >REMOVE</button> 
                       </form>
                       <div v-if="promocode.errors.length > 0" class="promocode-errors">
                         <ul class="mb-0 px-2 font-sm">
                          <li v-for="(error,i) in promocode.errors" :key="`promocode-error-${i}`" class="d-block text-danger">{{error}}</li>
                         </ul>
                       </div>
                    </div>
                  </div>
                </div>
                <div class="totals py-3">
                  <div class="d-flex justify-content-between border-top pb-2 pt-3">
                    <div class="">Sub total</div>
                    <div class="">£ {{subtotal.toFixed(2)}}</div>
                  </div>
                  <div class="d-flex justify-content-between pb-2">
                    <div class="">
                      <div>Delivery</div>
                      <div class="font-xs text-std-grey">Standard delivery: 3-5 working days.</div>
                    </div>
                    <div class="">£ {{deliveryCost.toFixed(2)}}</div>
                  </div>
                  <div v-if="promocode.value" class="d-flex justify-content-between pb-2">
                    <div class="text-danger">Discount code</div>
                    <div class="text-danger">- £ {{promocodeDiscount.toFixed(2)}}</div>
                  </div>
                  <div class="w-100 border-bottom my-2"></div>
                  <div class="d-flex bold-text justify-content-between py-2">
                    <div class="">Total</div>
                    <div class="">£ {{total.toFixed(2)}}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

  #promocodeValue {
    text-decoration: underline;
  }

  .btn-mw {
    min-width: 100px;
  }
  .arrow {
    right: 0;
    top: 0;
    i {
      font-size: 1rem;
      transition: all 0.5s;
      &.rotate180 {
        transform: rotate(180deg);
      }
    }
  }

  .product-thumbnail {
    background-size: contain;
    background-position: center;
    padding-bottom: 100%;
    background-repeat: no-repeat;
  }

  .product-preview {
    flex-grow: 1;
    overflow-y: auto;
    max-height: 20rem;
  }

</style>
