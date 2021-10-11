<script>

import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  mounted: function() {},
  data: function () {
    return {
      content: this.vueContent,
    }
  },
  methods:{
    getOrderDate: function(orderDateTime) {
      let date = new Date(orderDateTime);
      return date.toLocaleDateString('en-GB');
    },
    getOrderTime: function(orderDateTime) {
      let date = new Date(orderDateTime);
      return date.toLocaleTimeString('en-GB');
    },
    getOrderStatusText: function(status){
      switch(status) {
        case "PAID":
          return "Paid";
        case "NEW":
          return "waiting payment";
      }
    },
    getOrderStatusClass: function(status){
      switch(status) {
        case "PAID":
          return "paid";
        case "NEW":
          return "not-yet-paid";
      }
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
        <h2>Orders</h2>
      </div>
      <div v-if="content.orders.length > 0" class="col-12 py-5 mb-md-5 bg-white box-shadow">
        <div class="table-responsive">
          <table class="table">
            <thead>
              <tr>
                <th scope="col">Order</th>
                <th scope="col">Date</th>
                <th scope="col">Customer</th>
                <th scope="col">Status</th>
                <th scope="col">Total</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in content.orders" :key="`${order.id}-key`">
                <td><a :href="`/shops/my_shop/orders/${order.id}`">#{{order.id}}</a></td>
                <td>{{getOrderDate(order.date)}}</td>
                <td>{{order.user_info.email}}</td>
                <td><div class="d-inline pills" :class="getOrderStatusClass(order.status)">{{getOrderStatusText(order.status)}}</div></td>
                <td>£ {{(order.price / 100).toFixed(2)}}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div v-else class="col-12 py-5 mb-md-5 bg-white box-shadow">
        <h3 class="text-center py-3">Your orders will show here</h3>
        <p class="text-center">This is where you’ll manage your orders.</p>
      </div>
    </div>
  </div>

</template>

<style lang="scss" scoped>

  .pills {
    border-radius: 1rem;
    padding: 4px 18px;
    font-size: 0.85rem;
    font-weight: bold;
    
    &.paid {
      color: #699e73;
      background-color: #d4edd9;
    }

    &.not-yet-paid {
      color: #777;
      background-color: #eee;
    }
    
  }

  tbody {
    a {
      text-decoration: underline;
    }
    td {
      vertical-align: middle;
    }
  }

</style>
