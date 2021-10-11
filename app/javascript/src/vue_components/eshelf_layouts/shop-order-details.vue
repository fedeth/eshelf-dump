<script>

import { applicationMixin } from "src/modules/application_mixin.js";
// import { fooBar } from 'lodash';

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  // mounted: function() {},
  data: function () {
    return {
      content: this.vueContent,
    }
  },
  // methods:{},
  computed: {
    subTotal: function(){
      let subTotal = 0;
      this.content.products.forEach(product => {
        subTotal += product.price * product.quantity;
      });
      return (subTotal / 100);
    },
    delivery: function() {
      return this.pageModel.constants["STANDARD_SHIPPING_COST"] / 100;
    },
    total: function() {
      return (this.subTotal + this.delivery);
    }
  }
}
</script>

<template>
  <div class="container-fluid pt-4 pb-5 mb-lg-5">
    <div class="row">
      <div class="col-12 pb-3">
        <div class="py-3 d-flex align-items-center"><i class="fas fa-angle-left pr-2"></i>
        <a href="/shops/my_shop/orders" class="text-dark">All orders</a>
        </div>
        <h2>Order #{{content.order_id}}</h2>
      </div>
      <div class="col-12 col-lg-8 pb-5 pt-4 bg-white box-shadow">
        <h5 class="pb-5 m-0">Order details</h5>
        <div class="table-responsive">
          <table class="table">
            <tbody>
              <tr v-for="product in content.products" :key="`${product.id}-key`" >
                <td class="cell-thumbnail d-none d-md-table-cell">
                  <div class="product-thumbnail" :style="{'background-image': `url(${product.thumbnail})`}"></div>
                </td>
                <td><div>{{product.brand}} {{product.title}}</div></td>
                <td><div>£{{(product.price / 100).toFixed(2)}} x {{product.quantity}}</div></td>
                <td><div>£{{((product.price * product.quantity) / 100).toFixed(2)}}</div></td>
              </tr>
              <tr class="billing first-row">
                <td class="d-none d-md-table-cell"></td>
                <td></td>
                <td><div class="pt-4 pb-2">Subtotal</div></td>
                <td><div class="pt-4 pb-2">£{{subTotal.toFixed(2)}}</div></td>
              </tr>
              <tr class="billing">
                <td class="d-none d-md-table-cell"></td>
                <td></td>
                <td><div class="py-2">Delivery</div></td>
                <td><div class="py-2">£{{delivery.toFixed(2)}}</div></td>
              </tr>
              <tr class="billing">
                <td class="d-none d-md-table-cell"></td>
                <td></td>
                <td><div class="pt-2 pb-3"><b>Total</b></div></td>
                <td><div class="pt-2 pb-3"><b>£{{total.toFixed(2)}}</b></div></td>
              </tr>
              <tr class="billing last-row">
                <td class="d-none no-border d-md-table-cell"></td>
                <td class="no-border"></td>
                <td><div class="py-3">Paid by customer</div></td>
                <td><div class="py-3">£{{total.toFixed(2)}}</div></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="col-12 col-lg-4 mt-4 mt-lg-0">
        <div class="row pl-lg-4 sticky-top">
          <div class="col-12 bg-white box-shadow p-4">
            <h5 class="pb-4 m-0">Customer</h5>
            <div class="pb-5">{{content.user_info.email}}</div>
          </div>
          <div class="col-12 bg-white box-shadow mt-4 p-4">
            <h5 class="pb-4 m-0">Shipping address</h5>
            <div class="pb-5">
              <div>{{content.delivery_info.firstName}} {{content.delivery_info.lastName}}</div>
              <div>{{content.delivery_info.addressLine1}}</div>
              <div>{{content.delivery_info.addressLine2}}</div>
              <div>{{content.delivery_info.postcode}}</div>
              <div>{{content.delivery_info.phoneNumber}}</div>
             </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<style lang="scss" scoped>

  table {
    
    tr.billing {
    
      &.first-row, &.last-row {
        
        & td {
          border-top: 1px solid #dee2e6;

          &.no-border {
            border: none;
          }
        }
      }
    
      & td {
        border: none;
        padding-top: 0;
        padding-bottom: 0;
      }
    }
  }

  td {
     vertical-align: middle;
   }

  .product-thumbnail {
    width: 4rem;
    height: 4rem;
    background-size: contain;
    background-repeat: no-repeat;
    border-radius: 0.5rem;
    background-position: center;
  }

  .cell-thumbnail {
    width: 4rem;
  }


</style>
