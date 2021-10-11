<script>

export default {
  props: {
    'vueContent': {
      type: Object,
    }
  },
  data: function () {
    return {
      content: this.vueContent,
    }
  },
}
</script>

<template>
  <div class="bg-light-grey">
    <div class="container py-5">
      <div class="row pb-5 pt-3">
        <div class="d-none d-md-block col-auto col-sidebar">
          <static-page-sidebar></static-page-sidebar>
        </div>
        <div class="col p-5 bg-white">
          <h2 class="pb-5">Orders & Shipping </h2>
          <h4 class="pb-3">When will I receive my order?</h4>
          <p class="pb-5">The Standard delivery in the UK takes typically 3-5 days. Your product(s) will be shipped to you directly by the individual boutique(s), therefore shipping times can vary and your order may arrive in multiple packages.</p>
          <h4 class="pb-3">How much will I be charged for delivery?</h4>
          <p>This depends on the number of boutiques of your chosen products, you’ll see the cost at the checkout. The Standard delivery in the UK costs £9.90 per boutique. Please note your basket can contain products from different boutiques and each boutique shipment will be charged in your order.</p>
          <p class="pb-5">We offer a Free Shipping for orders above 100 GBP. This means you can purchase multiple pieces from multiple locations without being charged for the shipping.</p>
        </div>
      </div>
    </div>
  </div>
 
</template>

<style lang="scss" scoped>
  
</style>