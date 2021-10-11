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
          <h2 class="pb-5">Returns & Refunds</h2>
          <h4 class="pb-3">Returns Policy</h4>
          <p class="pb-5">You have 14 days from receipt of the product to let us know you want to return a product, and a further 14 days to return the product directly to the boutique for a refund. All products must be returned undamaged and unused, with all tags attached and the original packaging.</p>
          <h4 class="pb-3"> How can I return a product?</h4>
          <ol class="pb-3">
            <li class="py-2">Please email the customer service (customerservice@eshelf.co.uk) providing a reason for returning the product, adding any additional relevant information. Please note, your request to return a product must be submitted within 14 days of receiving your order.</li>
            <li class="py-2">Send your product back to the boutique at the address details we provide you, within 14 days of notifying us of your intention to return. We recommend sending your product by recorded delivery and retaining proof of postage just in case anything goes missing.</li>
            <li class="py-2">Ensure returned products are sent and received in their original packaging and in a re-sellable condition.</li>
          </ol>
          <p class="pb-5">As soon as your returned products have been received by the Boutique, we will be notified of the return. We will then contact you by email to let you know that your return has been received and your refund has been processed. Please allow 3-5 working days for the refund to be processed through your original payment method.</p>
          <h4 class="pb-3">Shipping Refund</h4>
          <p class="pb-5">If you receive a product in a flawed or damaged condition, we will refund the cost of return shipping if you are asked to return it back to the boutique. Please advise our Customer Service as soon as possible and we will arrange a return and process a full refund for the defective product.</p>
          <h4 class="pb-3">How long does a refund take?</h4>
          <p class="pb-5">Our Customer Service will always get in touch when a refund is due or has been requested. Once we receive the receipt confirmation from the boutiques please allow 3-5 working days for processing the refund and receive it back into your payment account.</p>
          <h4 class="pb-3">Further questions</h4>
          <p class="pb-5">If you have any further questions on our Returns policy, please contact our <a href="/contact_us">Customer Service</a>.</p>
        </div>
      </div>
    </div>
  </div>
 
</template>

<style lang="scss" scoped>
  
</style>