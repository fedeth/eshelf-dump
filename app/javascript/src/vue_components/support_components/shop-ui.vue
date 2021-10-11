<script>
import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  mixins: [applicationMixin],
  data: function () {
    return {
      menuLinks: [["Products", "/shops/my_shop/products", "fas fa-tags"],["Orders", "/shops/my_shop/orders","fas fa-file-alt"]]
    }
  },
  methods: {
    isItemActive(path) {
      return window.location.href.includes(path);
    },
  },
  computed: {
    flashNotice() {
     return this.pageModel.rails_flash_messages.notice ? this.pageModel.rails_flash_messages.notice : null;
    },
    flashAlert() {
      return this.pageModel.rails_flash_messages.alert ? this.pageModel.rails_flash_messages.alert : null;
    }
  }
}
</script>

<template>
<div class="w-100 bg-light-grey">
  <shop-header :menu-links="menuLinks"></shop-header>
  <div class="container">
    <div class="row">
      <div class="d-none d-md-flex desktop-sidebar border-right bs-4-slot-modal-fix">
        <div>
        <ul class="py-3 pl-0 sticky-top">
          <li v-for="menuLink in menuLinks" :key="`${menuLink[0]}`" class="d-block menu-link py-2">
            <div class="pr-2 icon-menu-container d-inline-block">
              <i :class="menuLink[2]"></i>
            </div>
            <a :href="menuLink[1]">{{menuLink[0]}}</a>
          </li>
        </ul>
        </div>
      </div>
      <div class="col-12 col-md pl-md-5">
        <div v-if="flashNotice" class="alert alert-success my-4 alert-dismissible">
          <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
          <div v-html="flashNotice"></div>
        </div>
        <div v-if="flashAlert" class="alert alert-danger my-4 alert-dismissible">
          <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
          <div v-html="flashAlert"></div>
        </div>
        <slot></slot>
      </div>
    </div>
  </div>
</div>

</template>

<style lang="scss" scoped>

  // fix strange behaviour occurred when you open bs modal inside a vue's <slot>
  .bs-4-slot-modal-fix {
    margin-right: 0 !important;
    padding-right: 0 !important;
  }

  .desktop-sidebar {
    width: 10rem;
  }

  .icon-menu-container{
    width: 1.5rem;
  }

  .shop-name {
    font-size: 1.25rem;
  }

  [layer-dark] {
    background-color: rgba($black, .55);
    z-index: 10;
    top: 0;
  }

  .menu-link {
    a {
      color: $dark-grey;
      &:hover{
        font-weight: bold;
      }
    }
  }
 
</style>
