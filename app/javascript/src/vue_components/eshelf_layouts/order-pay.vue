<script>

import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  data: function () {
    return {
      content: this.vueContent,
      paymentInProgress: false,
    }
  },
  mounted: function() {
    // TODO: Split in functions these code blocks
    this.stripe = Stripe(this.content.public_key);
    this.elements = this.stripe.elements();
    const style = {
      base: {
        color: '#32325d',
        fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
        fontSmoothing: 'antialiased',
        fontSize: '16px',
        '::placeholder': {
          color: '#999'
        }
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a'
      }
    };
    this.card = this.elements.create('card', {style: style});
    this.card.mount('#card-element');
    // Handle real-time validation errors from the card Element.
    var displayError = document.getElementById('card-errors');
    this.card.addEventListener('change', function(event) {
      if (event.error) {
        displayError.textContent = event.error.message;
      } else {
        displayError.textContent = '';
      }
    });

    if(window.dataLayer){
      window.dataLayer.push({
        'event': 'checkout_option', 
        'ecommerce': {
          'checkout': {
            'actionField': {
              'step': 2,
              'option': 'postcode'
            }
          }
        }
      });
    }

  },
  methods:{
    submitPayment: function(){
      const cmp = this;
      this.paymentInProgress = true;

      const succesPaymentCallback = (paymentIntent) => {
        ApplicationModule.postDataForm({
          url: "/api/v1/order/verify_stripe_payment",
          data: {payment_intent: paymentIntent},
          success: (result) => {
            if(result.success == true){
              window.location.replace(`/order/${cmp.content.order_info.id}/show`);
            } else if(result.error){
              console.log(result.error);
              this.paymentInProgress = false;
            }
          },
          error: (err) => {
            this.paymentInProgress = false;
          }
        });
      };

      this.stripe.confirmCardPayment(
        this.content.client_secret, { payment_method: { card: this.card }}
      ).then(function(result) {
        if(result.paymentIntent){
          succesPaymentCallback(result.paymentIntent);
        } else if(result.error) {
          console.log(result.error);
          cmp.paymentInProgress = false;
        }
      });
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
  }
}
</script>

<template>
  <div class="w-100 bg-light-grey">
    <loading-spinner v-if="paymentInProgress"></loading-spinner>
    <div class="container py-5">
      <div class="row justify-content-center pb-4">
        <div class="col-12 col-sm-10 col-xl-9">
          <order-progress :progress="content.order_info.status"></order-progress>
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-md-8 p-3 p-md-5 order-2 order-md-1 bg-white">
          <h2 class="pb-4 pt-4 pt-md-0">Secure payment</h2>
          <div class="pt-md-5">
            <div id="card-element"></div>
            <div id="card-errors" class="pb-3" role="alert"></div>
          </div>
          <div class="d-inline-flex flex-column w-100">
            <button id="pay-button" class="btn btn-dark w-100" :disabled="paymentInProgress" @click="submitPayment()">Pay</button>
            <div class="disclaimer text-center text-std-grey pt-2">
              <i class="fas fa-lock pr-1"></i>Secure payment powerd by Stripe™
            </div>
          </div>
        </div>
        <div class="col-12 col-md-4 order-1 order-md-2">
          <div class="row pl-md-4 h-100">
            <div class="col-12 d-flex flex-column px-4 bg-white">
              <h5 class="text-center py-4">Summary</h5>
              <div class="product-preview d-flex flex-column">
                <div v-for="product in content.products" :key="`product-${product.id}`" class="w-100 row pb-3">
                  <div class="col-3">
                    <div class="product-thumbnail w-100" :style="{backgroundImage: `url(${product.thumbnail})`}"></div>
                  </div>
                  <div class="col-5 d-flex align-items-center">Quantity: {{product.quantity}}</div>
                  <div class="col-4 d-flex align-items-center">£ {{(product.price / 100).toFixed(2)}}</div>
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
                <div v-if="promocodeDiscount != 0" class="d-flex justify-content-between pb-2">
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
</template>

<style lang="scss" scoped>

  .product-thumbnail {
    background-size: contain;
    background-position: center;
    padding-bottom: 100%;
    background-repeat: no-repeat;
  }

  .product-preview {
    flex-grow: 1;
  }

  // Stripe Style
  #card-errors {
    min-height: 1.5rem;
  }

  .StripeElement {
    box-sizing: border-box;
    height: 40px;
    padding: 10px 12px;
    border: 1px solid transparent;
    border-radius: 4px;
    background-color: white;
    box-shadow: 0 1px 3px 0 #bbb;
    -webkit-transition: box-shadow 150ms ease;
    transition: box-shadow 150ms ease;
  }

  .StripeElement--focus {
    box-shadow: 0 1px 3px 0 #cfd7df;
  }

  .StripeElement--invalid {
    border-color: #fa755a;
  }

  .StripeElement--webkit-autofill {
    background-color: #fefde5 !important;
  }

</style>
