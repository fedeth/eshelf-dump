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
          <h2 class="pb-5">Help & Contact us</h2>
          <p>If you have a question, please check our FAQs section as you may find a quick answer. If you still need help, please contact our Customer Service via mail or over the phone.</p>
          <div class="row pt-5">
            <div class="col-12 col-md-6">
              <h4><span class="pr-3"><i class="fas fa-envelope"></i></span>Email us</h4>
              <div class="py-4">
                <b><a class="text-black" href="mailto:customerservice@eshelf.co.uk">customerservice@eshelf.co.uk</a></b>
              </div>
              <p class="pr-md-5">We aim to respond within 24 hours, however, during busy periods like holidays or promotional sales we may take a bit longer getting back to you.</p>
            </div>
            <!-- <div class="col-12 col-md-6">
              <h4><span class="pr-3"><i class="fas fa-phone-alt"></i></span>Call us</h4>
              <div class="py-4">
                <b><a class="text-black" href="tel:+44-7551-284603">+44 (0) 7551 284603</a></b>
              </div>
              <p class="pr-md-5">Available Monday to Friday 8am-11PM GMT</p>
            </div> -->
          </div>
        </div>
      </div>
    </div>
  </div>
 
</template>

<style lang="scss" scoped>
  b {
    font-weight: 500;
  }
  
</style>