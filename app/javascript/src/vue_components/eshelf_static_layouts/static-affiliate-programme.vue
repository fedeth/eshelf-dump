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
        <div class="col">
          <div class="row">
            <div class="col-12 p-5 bg-white">
              <h2 class="pb-5">Affiliate Programme</h2>
              <p class="pb-5">We are looking for original, modern, trendy, home and gift focused websites, influencers and blogs to join our affiliate program and promote our fast-growing brand in the UK</p>
              <h4 class="pb-3">Why join us?</h4>
              <ul class="pb-5">
                <li class="py-2">Free to join</li>
                <li class="py-2">Commission on sales (30 days cookie window)</li>
                <li class="py-2">Full data feed on our products</li>
                <li class="py-2">Competitions and giveaways</li>
                <li class="py-2">Regular newsletter to keep you up to date on new products, new boutiques and promotions.</li>
              </ul>
              <h4 class="pb-3">About eShelf</h4>
              <p class="pb-5">We aim to offer a curated selection of the finest home decor products in one single digital space. We search for the most innovative, trendy and stylish artists, designers and boutiques so you can easily discover distinctive, appealing items to personalise your home without having to leave the comfort of it.</p>
            </div>
            <div class="col-12 p-5 mt-5 bg-white">
               <h4 class="pb-3">Join eShelf affiliate programme</h4>
               <div class="py-4">
                 <span class="pr-3"><i class="fas fa-envelope"></i></span>
                 <a class="text-black" href="mailto:affiliates@eshelf.co.uk">affiliates@eshelf.co.uk</a>
               </div>
               <p class="pb-4">Please email us the name and the URL of your website or blog and your social media accounts. Our team will review your site and respond to you with additional information about our affiliate program.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
 
</template>

<style lang="scss" scoped>
  
</style>
