<script>
export default {
  data: function () {
    return {

    }
  }
}
</script>

<template>
  <div class="footer bg-purple text-white">
    <div class="container pt-5 pb-4">
      <div class="row">
        <div class="col-12 pb-5">
          <img src="~src/pictures/eshelf_logo_white.png" width="80">
        </div>
      </div>
      <div class="row">
        <div class="col-12 col-sm-9">
          <div class="row">
            <div class="col-6 col-sm-4">
              <div class="footer-text pb-2">CUSTOMER SERVICE</div>
              <ul class="p-0">
                <template v-for="(link, index) in [['Help & Contact Us','/contact_us'],['Orders & Shipping', '/orders_and_shipping'],['Payment', 'payment_and_pricing'],['Returns & Refunds','/returns_and_refunds'], ['FAQs','/faqs']]">
                  <li class="d-block py-2 font-sm" :key="`discover-${index}`">
                    <a :href="link[1]">{{link[0]}}</a>
                  </li>
                </template>
              </ul>
            </div>
            <div class="col-6 col-sm-4">
              <div class="footer-text">ABOUT ESHELF</div>
              <ul class="p-0">
                <template v-for="(link, index) in [['About Us','/about_us'], ['Sell with us', '/sell_with_us'],['Affiliate Programme', '/affiliate_programme']]">
                  <li class="d-block py-2 font-sm" :key="`discover-${index}`">
                    <a :href="link[1]">{{link[0]}}</a>
                  </li>
                </template>
              </ul>
            </div>
            <div class="col-6 col-sm-4  pt-4 pt-sm-0">
              <div class="footer-text">LEGAL</div>
              <ul class="p-0">
                <template v-for="(link, index) in [['Terms & Conditions','terms_and_conditions'],['Privacy Policy','/privacy_policy'],['Cookie Policy','/cookie_policy']]">
                  <li class="d-block py-2 font-sm" :key="`discover-${index}`">
                    <a :href="link[1]">{{link[0]}}</a>
                  </li>
                </template>
              </ul>
            </div>
            <div class="col-6 d-sm-none pt-4 pt-sm-0">
              <div class="footer-text">Follow Us</div>
              <div class="social-icons py-3">
                <a href="https://www.instagram.com/eshelf.co.uk/" target="_blank"><i class="fab fa-instagram pr-3"></i></a>
                <a href="https://www.pinterest.it/eShelfcouk/" target="_blank"><i class="fab fa-pinterest-p pr-3"></i></a>
                <a href="https://www.facebook.com/eShelf.co.uk/" target="_blank"><i class="fab fa-facebook-f pr-3"></i></a>
              </div>  
            </div>
          </div>
        </div>
        <div class="d-none d-sm-block col-3">
          <div class="footer-text">Follow Us</div>
          <div class="social-icons py-3">
            <a href="https://www.instagram.com/eshelf.co.uk/" target="_blank"><i class="fab fa-instagram pr-3"></i></a>
            <a href="https://www.pinterest.it/eShelfcouk/" target="_blank"><i class="fab fa-pinterest-p pr-3"></i></a>
            <a href="https://www.facebook.com/eShelf.co.uk/" target="_blank"><i class="fab fa-facebook-f pr-3"></i></a>
          </div>  
        </div>
        <div class="col-12 text-center pt-4 pt-md-5">
          <small>© Copyright 2020 eShelf. All rights reserved.</small>
          <small>
            This site is protected by reCAPTCHA and the Google
            <a href="https://policies.google.com/privacy">Privacy Policy</a> and
            <a href="https://policies.google.com/terms">Terms of Service</a> apply.
          </small>  
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  i {
    font-size: 1.75rem;
  }

  a {
    color: $light-grey;
    &:hover {color: $white;}
  }

</style>
