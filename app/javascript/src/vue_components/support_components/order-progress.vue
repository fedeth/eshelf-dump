<script>

import { applicationMixin } from "src/modules/application_mixin.js";
// import { fooBar } from 'lodash';

export default {
  props: ['progress'],
  // mixins: [applicationMixin],
  mounted: function() {
    console.log("component mounted");
  },
  data: function () {
    return {
      foo: { bar: 1},
    }
  },
  methods:{
    fooBarMethod: function() { },
  },
  computed: {
    deliveryText: function() {
      return this.progress == null ? "Delivery" : "Delivery info collected";
    },
    paymentText: function() {
      return this.progress == "PAID" ? "Order paid" : "Payment";
    },
    confirmText: function() {
      return this.progress == "PAID" ? "Order confirmed" : "Confirmation";
    }, 
    deliveryClass: function() {
      return this.progress == null ? "doing" : "done";
    }, 
    paymentClass: function() {

      return this.progress == null ? "todo" : this.progress == "NEW" ? "doing" : "done";
    },
    confirmClass: function() {
      return this.progress == "PAID" ? "doing" : "todo";
    },
  }
}
</script>

<template>
  <div class="w-100 d-flex justify-content-between">
    <div class="progress-section" :class="deliveryClass">
      <div class="pt-100 position-relative">
        <div class="progress-cell position-absolute d-flex flex-column align-items-center justify-content-center">
          <div class="step d-flex align-items-center justify-content-center"><i class="fas fa-box-open"></i></div>
          <div class="d-none d-md-flex align-items-center justify-content-center pt-2">{{deliveryText}}</div>
        </div>
      </div>
    </div>
    <div class="progress-section done spacer">
      <div class="hr"></div>
    </div>
    <div class="progress-section" :class="paymentClass">
      <div class="pt-100 position-relative">
        <div class="progress-cell position-absolute d-flex flex-column align-items-center justify-content-center">
          <div class="step d-flex align-items-center justify-content-center"><i class="far fa-credit-card"></i></div>
          <div class="d-none d-md-flex align-items-center justify-content-center pt-2">{{paymentText}}</div>
        </div>
      </div>
    </div>
    <div class="progress-section spacer">
      <div class="hr"></div>
    </div>
    <div class="progress-section" :class="confirmClass">
      <div class="pt-100 position-relative">
        <div class=" progress-cell position-absolute d-flex flex-column align-items-center justify-content-center">
          <div class="step d-flex align-items-center justify-content-center"><i class="fas fa-check"></i></div>
          <div class="d-none d-md-flex align-items-center justify-content-center pt-2">{{confirmText}}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .pt-100{
    padding-top: 100%;
  }

  .progress-section {
    flex: 1;

    @include media-breakpoint-down(md) {
      flex: 3;

      &.spacer {
        flex: 1;
      }
    }

    .hr {
      height: 40%;
      border-bottom: solid 1px;
      color: $hp-grey;
      @include media-breakpoint-down(md) {
        height: 50%;
      }
    }

    .progress-cell {
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;

      .step {
        border: solid 2px $dark-grey;
        border-radius: 50%;
        height: 50%;
        width: 50%;
        font-size: 1.75rem;

        @include media-breakpoint-down(md) {
          height: 70%;
          width: 70%;
        }

      }
    }

    &.doing {
      .progress-cell {
        color: #000;
        .step {
          border-color: $dark-grey;
          background-color: #343a40;
          color: #fff;
        }
      }
    }

    &.done {
      .progress-cell {
        color: #a0a0a0;
        .step {
          border-color: #cacaca;
          background-color: #efefef;
        }
      }
    }

    &.todo {
      .progress-cell {
        color: #727272;
        .step {
          border-color: #cacaca;
          background-color: #fff;
        }
      }
    }

  }
</style>
