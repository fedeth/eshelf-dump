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
          <h2 class="pb-5">Payment</h2>
          <p>Our payments are extra-safe, being managed through Stripe, the same third-party provider that powers the world’s largest companies such as Amazon, Google and Microsoft.</p>
          <p class="pb-5">We also use Strong Customer Authentication (SCA), the new European regulatory requirement to reduce fraud and make online payments more secure.</p>
          <h4 class="pb-3">What payment methods do you accept?</h4>
          <ul class="pb-5">
            <li class="py-2">Visa</li>
            <li class="py-2">Mastercard</li>
            <li class="py-2">Maestro</li>
            <li class="py-2">American Express</li>
          </ul>
          <h4 class="pb-3">Will my personal details stay safe?</h4>
          <p class="pb-5">We keep your personal data private and confidential and only give it out with your consent or if legally permitted to. For further details, please see our Privacy Policy.</p>
        </div>
      </div>
    </div>
  </div>
 
</template>

<style lang="scss" scoped>
  
</style>