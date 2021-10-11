<script>
import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  props: ['menuLinks'],
  mixins: [applicationMixin],
  data: function () {
    return {
      sidebarOpen:false,
      showSidebarLayer: false,
    }
   },
  methods: {
    toggleShopPanel() {
      let shopPanel = document.getElementById("shopPanel");
      let userIcon = document.getElementById("usrIcon");
      shopPanel.classList.toggle("show-panel");
      userIcon.classList.toggle("fa-user");
      userIcon.classList.toggle("fa-times");
    },
  },
  computed: {
    shopName() {
      return this.pageModel.shop_info.legal_name;
    },
  }
}
</script>

<template>
  <div class="bg-purple">
    <div class="container">
      <div class="row">
        <div class="col-12 d-flex justify-content-between align-items-center text-white header-height">
          <div class="d-none d-md-flex align-items-center">
            <a href="/">
              <img src="~src/pictures/eshelf_logo_white.png" width="80">
            </a>
          </div>
          <div class="hamburger d-block d-md-none mr-3 cursor-pointer" @click="sidebarOpen = true">
            <i class="bars-properties fas fa-bars"></i>
          </div>
          <div @click="toggleShopPanel()" class="d-flex align-items-center cursor-pointer shop-name">
            <span class="pr-3 d-none d-md-block">{{shopName}}</span>
            <i  id="usrIcon" class="fas fa-user"></i>
          </div>
          <nav class="shopper-panel position-absolute bg-white border-top" id="shopPanel">
            <ul class="py-3 px-0 my-0">
              <li class="px-3 pb-3 text-black border-bottom">
                <a href="/shops/my_shop" class="text-dark">{{shopName}}</a>
              </li>
              <li class="px-3 pt-3">
                <a class="shopper-panel-item" href="#">FAQs</a>
              </li>
              <li class="px-3 pt-3">
                <a class="shopper-panel-item" href="/shops/sign_out">Log out</a>
              </li>
            </ul>
          </nav>
        </div>
      </div>
    </div>
    <transition enter-active-class="animated faster fadeIn" leave-active-class="animated faster fadeOut">
      <div class="w-100 h-100 position-fixed" v-if="showSidebarLayer" layer-dark></div>
    </transition>
    <transition 
      enter-active-class="animated faster slideInLeft" 
      leave-active-class="animated faster slideOutLeft"
      v-on:after-enter="showSidebarLayer = true"
      v-on:before-leave="showSidebarLayer = false"
    >
      <shop-sidebar 
      v-if="sidebarOpen"
      :menu-links="menuLinks"
      v-on:sidebar-close="sidebarOpen = false"
    ></shop-sidebar>
    </transition>
  </div>
</template>

<style lang="scss" scoped>

.header-height {
  height: 70px; 
}

.shopper-panel {
  transition: all 0.4s;
  opacity: 0;
  visibility: hidden;
  right: 4px;
  top: 100%;
  z-index: 5;
  min-width: 250px;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
  
  &.show-panel {
    visibility: visible;
    opacity: 1;
  }

  li {
    display: block;
  }

  .shopper-panel-item {
    color: $dark-grey;
    font-size: 1.1rem;
    &:hover {
      color: #000;
    }
    &.active {
      font-weight: bold;
    }
  }

  @include media-breakpoint-down(xs){
    left: 0;
    right: 0;
  }
}

@include media-breakpoint-down(md) {
  .bars-properties {
    font-size: 1.25rem;
  }
  .header-height {
    height: 3rem;
  }
}
  
</style>