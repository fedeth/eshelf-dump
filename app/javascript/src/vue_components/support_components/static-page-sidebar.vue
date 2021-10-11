<script>
export default {
  
}
</script>
<template>
  <ul class="static-sidebar sticky-top py-4 px-0">
    <li class="d-block my-2"><a href="/faqs">FAQs</a></li>
    <li class="d-block my-2"><a href="/orders_and_shipping">Orders & Shipping</a></li>
    <li class="d-block mt-2"><a href="/payment_and_pricing">Payment</a></li>
    <li class="d-block my-2"><a href="/returns_and_refunds">Returns & Refunds</a></li>
    <li class="d-block my-5"><a href="/affiliate_programme">Affiliate Programme</a></li>
    <li class="d-block my-2"><a href="/terms_and_conditions">Terms & Conditions</a></li>
    <li class="d-block my-2"><a href="/privacy_policy">Privacy Policy</a></li>
    <li class="d-block my-2"><a href="/cookie_policy">Cookie Policy</a></li>
    <li class="d-block my-5"><a href="/contact_us">Help & Contact Us</a></li>
  </ul>
</template>
<style lang="scss" scoped>
  .static-sidebar {
    width: 16rem;
    a {
      color: $dark-grey;
      text-decoration: underline;
      &:hover {
        color: #000;
      }
    }
  }
  
</style>