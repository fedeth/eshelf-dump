<script>

import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  //props: ['vueContent'],
  mixins: [applicationMixin],
  data: function () {
    return {
      //content: this.vueContent,
    }
  },
}
</script>

<template>
  <div class="container py-5">
    <div class="row">
      <div class="col-12 col-md-6 flex-column justify-content-center align-items-center d-flex">
        <h3>Lorem ipsum sit amet</h3>
        <p class="text-center py-3">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Faucibus scelerisque eleifend donec pretium vulputate sapien nec sagittis aliquam. Velit euismod in pellentesque massa placerat duis ultricies. </p>
        <div class="text-center">
          <a role="button" href="/collections" class="btn btn-dark px-5">Discover collections</a>
        </div>
      </div>
      <div class="d-none d-md-flex col-md-6">
        <div class="bg-wrapper bg-light-grey w-100"></div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

  .bg-wrapper {
    padding-top: 75%;
  }

</style>
