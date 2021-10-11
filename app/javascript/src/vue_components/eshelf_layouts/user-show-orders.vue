<script>

import { applicationMixin } from "src/modules/application_mixin.js";
import { isEmpty } from 'lodash';

export default {
  props: ['content'],
  mixins: [applicationMixin],
  mounted: function() {},
  data: function () {
    return {
      foo: { bar: 1},
    }
  },
  methods:{
    getOrderStatusString(orderStatus) {
      switch(orderStatus){
        case "NEW":
          return "Pending";
        case "PAID":
          return "Paid";
        default:
          return "---";
      }
    },
    getOrderDateTime: function(orderDateTime) {
      let date = new Date(orderDateTime);
      return date.toLocaleDateString('en-GB') + " " + date.toLocaleTimeString('en-GB');
    },
    getOrderStatusUrl(order){
      // TODO: consider to use switch case
      if(order.status == "NEW") {
        return "payment";
      } else if(order.status == "PAID") {
        return "show?completed=true";
      }
    },
  },
  computed: {
    completedOrders: function(){
      let completedOrders = [];
      this.content.orders.forEach(order => {
        if(order.status == "PAID") {
            completedOrders.push(order);
          }
      });
      return completedOrders;
    },
    newOrders: function(){
      let newOrders = [];
      this.content.orders.forEach(order => {
        if(order.status == "NEW") {
            newOrders.push(order);
          }
      });
      return newOrders;
    },
  }
}
</script>

<template>
  <div class="container py-5">
    <div class="row">
      <div class="col-12">
        <h1 class="pb-3">My orders</h1>
      </div>
      <div class="col-12 pb-3">
        <ul class="nav nav-tabs nav-justified">
          <li class="nav-item">
            <a class="nav-link active text-black" href="#orders" data-toggle="tab">Orders</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-black" href="#openOrders" data-toggle="tab">Open orders</a>
          </li>
        </ul>
      </div>
      <div class="tab-content col-12 mh-35-vh">
        <div id="orders" class="tab-pane fade show active">
          <div v-if="completedOrders.length > 0" class="table-responsive-sm">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th scope="col-6" class="border-top-0">Date</th>
                  <th scope="col-6" class="border-top-0">Price</th>
                  <th scope="col-6" class="border-top-0">Status</th>
                  <th scope="col" class="border-top-0"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="order in completedOrders" :key="`order-list-${order.order_id}`">
                  <td>{{getOrderDateTime(order.created_at)}}</td>
                  <td>{{(order.price / 100).toFixed(2)}}£</td>
                  <td>{{getOrderStatusString(order.status)}}</td>
                  <td><a :href="`/order/${order.order_id}/${getOrderStatusUrl(order)}`">Details</a></td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else>
            <h4 class="py-4 text-std-grey">Your order history is empty.</h4>
          </div>
        </div>
        <div id="openOrders" class="tab-pane fade">
          <div v-if="newOrders.length > 0" class="table-responsive-sm">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th scope="col-6" class="border-top-0">Date</th>
                  <th scope="col-6" class="border-top-0">Price</th>
                  <th scope="col-6" class="border-top-0">Status</th>
                  <th scope="col" class="border-top-0"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="order in newOrders" :key="`order-list-${order.order_id}`">
                  <td>{{getOrderDateTime(order.created_at)}}</td>
                  <td>{{(order.price / 100).toFixed(2)}}£</td>
                  <td>{{getOrderStatusString(order.status)}}</td>
                  <td><a :href="`/order/${order.order_id}/${getOrderStatusUrl(order)}`">Details</a></td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else>
            <h4 class="py-4 text-std-grey">Your order history is empty.</h4>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .mh-35-vh {
    min-height: 35vh;
  }

  .nav-item {
    max-width: 16rem;
  }

  .nav-link {
    border: none;
  }

  .nav-link.active {
    border-bottom: 3px solid;
  }
</style>
