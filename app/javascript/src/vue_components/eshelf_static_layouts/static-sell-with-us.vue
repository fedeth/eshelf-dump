<script>

// import { applicationMixin } from "src/modules/application_mixin.js";
// import { fooBar } from 'lodash';

export default {
  // mixins: [applicationMixin],
  props: {
    'vueContent': {
      type: Object,
    }
  },
  data: function () {
    return {
      content: this.vueContent,
      openModal: false
    }
  },
}
</script>

<template>
  <div>
    <div class="container py-md-5">
      <div class="row main-section justify-content-center">
        <div class="col-12 col-md-11 col-lg-10 col-xl-10 pb-4 pb-md-5">
          <h2 class="text-center py-4 py-md-5">Become our partner</h2>
          <img class="d-block d-md-none img-fluid pb-4" src="~src/pictures/become_a_partner_banner_mobile.png">
          <img class="d-none d-md-block img-fluid pb-5" src="~src/pictures/become_a_partner_banner.jpg">
          <p>We are looking for the finest and most stylish boutiques, designers, and artists specialising in home decor to sell a unique range of products on our platform.</p>
          <p>We want to enable customers to discover a curated selection of home decor products from the finest sellers. eShelf aims to empower boutiques, designers, and artists with a dedicated digital sales channel.</p>
          <p>You have the unique opportunity to present and sell their products to our growing network of home decor enthusiasts.</p>
        </div>
      </div>
      <div class="row secondary-section justify-content-center">
        <div class="col-12">
          <h2 class="text-center py-4 py-md-5"> Why join us:</h2>
        </div>
        <div class="col-12 col-md-4 pt-4 text-center">
          <h4>1. Expand your business</h4>
          <p class="px-4">Add an additional digital sales channel to your fantastic boutiques and reach new customers with us.</p>
        </div>
        <div class="col-12 col-md-4 pt-4 text-center">
          <h4> 2. No set up costs</h4>
          <p class="px-4">Free product listing and no monthly subscription for our service. We only take a small commission per order.</p>
        </div>
        <div class="col-12 col-md-4 pt-4 text-center">
          <h4 class="">3. Join our network</h4>
          <p class="px-4">Our growing network is made up of home decor enthusiasts always looking for the next trends from the finest boutiques and artists.</p>
        </div>
      </div>
      <div class="row secondary-section justify-content-center">
        <div class="col-12 text-center py-5">
          <a href="#" type="button" @click.prevent="openModal = true" class="btn btn-lg btn-dark px-5">Apply now</a>
        </div>
      </div>
    </div>
    <modal-seller-join-us :open-modal-signal="openModal" v-on:close-modal="openModal = false"></modal-seller-join-us>
  </div>
</template>

<style lang="scss" scoped>
  .main-section {
    p {
      font-size: 1.25rem;
    }
  } 

  .secondary-section {
    p {
      font-size: 1.15rem;
    }
  }

</style>
