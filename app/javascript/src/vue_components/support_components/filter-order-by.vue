<script>
import { applicationMixin } from "src/modules/application_mixin.js";
import { get } from 'lodash';

export default {
  mixins: [applicationMixin],
  mounted() {
    const orderMode = get(globalState.pageModel, ["search_params", "sort_by"], 'sort_by');
    const index = this.orders.findIndex((o) => o[0] === orderMode);
    if (index >= 0) {
      this.orderBy = {
        order: this.orders[index][0],
        label: this.orders[index][1]
      }
    }
  },
  data() {
    return {
      orders: [
        ["price_asc", "Price Ascending"],
        ["price_desc", "Price Descending"],
        ["created_at_desc", "New arrivals"]
      ],
      orderBy: {order:"", label:"Sort by"},
    }
  },
  methods:{
    setOrderBy(orderId) {
      this.orderBy.order = this.orders[orderId][0];
      this.orderBy.label = this.orders[orderId][1];
      this.$emit("update-order-by-filter", this.orderBy.order);
    },
  },
  computed: {}
}
</script>

<template>
  <div class="pl-lg-2 dropdown">
    <button
      class="btn btn-lg-sm btn-outline-dark dropdown-toggle order-button"
      id="dropdownMenuButton"
      data-toggle="dropdown"
      aria-expanded="false"
      aria-haspopup="true"
      type="button"
    >
      {{orderBy.label}}
    </button>
    <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
      <div class="dropdown-item cursor-pointer" @click="setOrderBy(0)" v-if="orderBy.order != 'price_asc'">Price: asc</div>
      <div class="dropdown-item cursor-pointer" @click="setOrderBy(1)" v-if="orderBy.order != 'price_desc'">Price: desc</div>
      <div class="dropdown-item cursor-pointer" @click="setOrderBy(2)" v-if="orderBy.order != 'created_at_desc'">New arrivals</div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .dropdown-menu {
    min-width: 95%;
  }

  .order-button {
    min-width: 150px;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  @include media-breakpoint-down(md) {
    .order-button,
    .dropdown {
      width: 100%;
    }
  }

  @include media-breakpoint-up(lg) {
    .btn-lg-sm {
      padding: 0.25rem 0.5rem;
      font-size: 0.875rem;
      line-height: 1.5;
      border-radius: 0.2rem;
    }
  }
</style>
