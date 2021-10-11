<script>

import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  mounted: function() {
    $('#collectCodeModal').on('hidden.bs.modal', (e) => { 
      this.modal.collectCode = null;
      this.modal.orderId = null;
    });
  },
  data: function () {
    return {
      content: this.vueContent,
      modal: {
        collectCode: null,
        orderId: null,
      }
    };
  },
  methods:{
    openCollectCodeModal: function(orderId){
      this.modal.orderId = orderId;
      $('#collectCodeModal').modal('show');
    },
  },
  computed: {
  },
}
</script>

<template>
  <div class="container py-5">
    <div class="row">
      <div class="col-12">
        <h1>Orders</h1>
      </div>
      <div class="col-12">
        <div v-if="content.orders" class="table-responsive">
          <table class="table table-striped">
            <thead>
              <tr>
                <th scope="col">Id</th>
                <th scope="col">Product Name</th>
                <th scope="col">Price</th>
                <th scope="col">Status</th>
                <th scope="col">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in content.orders" :key="`order-${order.order_id}`">
                <td>{{order.order_id}}</td>
                <td><a :href="`shops/my_shop/orders/${order.order_id}`">{{order.product_name}}</a></td>
                <td>{{order.product_price}}</td>
                <td>{{order.status}}</td>
                <td>
                  <span v-if="order.status == 'Paid'" class="action_link">Confirm availability</span>
                  <span v-if="order.status == 'Ready To Collect'" class="action_link">Insert collect code</span>
                  <span v-if="order.status == 'Collected'" class=" text-std-grey">Transaction details</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="modal fade" id="collectCodeModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header border-0">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-12">
              <div class="input-group input-group-lg">
                <div class="input-group-prepend">
                  <span class="input-group-text" id="inputGroup-sizing-lg">Collect code:</span>
                </div>
                <input type="text" maxlength="6" minlength="6" v-model="modal.collectCode" class="form-control text-center" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer border-0 justify-content-center">
          <button type="button" class="btn btn-primary">Submit</button>
        </div>
      </div>
    </div>
  </div>
  </div>
</template>

<style lang="scss" scoped>
  
  .action_link {
    text-decoration: underline;
    cursor: pointer;
    &:hover {
      color: #00c;
    }
  }

</style>
