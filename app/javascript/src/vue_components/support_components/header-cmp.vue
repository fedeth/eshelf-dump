<script>
const get = require('lodash.get');
import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  mixins: [applicationMixin],
  props: ['content'],
  data: function () {
    return {
      openMenu: false,
    }
  },
  methods: {
    isItemActive(path) {
      return window.location.href.includes(path);
    },
    toggleMenu() {
      let menuPanel = document.getElementById("menuPanel");
      let hbMenu = document.getElementById("hbMenu");
      menuPanel.classList.toggle("show-menu");
      hbMenu.classList.toggle("fa-bars");
      hbMenu.classList.toggle("fa-times");
    }
  },
  computed: {
    userInfo() {
      return get(this.pageModel, ['user_info', 'anonymous'], false) ? null : get(this.pageModel, ['user_info'], null);
    },
    basketProductsNumber() {
      return this.pageModel.cart_info.products_types_quantity ? this.pageModel.cart_info.products_types_quantity : null;
    },
    showFullHeader() {
      const urlParams = new URLSearchParams(window.location.search);
      const actionCompleted = urlParams.get('completed');
      if (actionCompleted) {
        return true;
      } else {
        let forbiddenPaths = /(\/order\/new|\/order\/\d{1,8})|\/users\/sign_in|\/users\/sign_up/;
        return !forbiddenPaths.test(this.pageModel.path);
      }
    }
  }
}
</script>

<template>
  <div class="w-100 border-bottom" :class="[content && content.action == 'home' ? 'bg-white': 'bg-white']">
    <div class="container">
      <div class="row">
        <div class="col-12 px-0 py-1 position-relative">
          <nav class="navbar navbar-light navbar-expand-lg px-md-0">
            <a class="navbar-brand" href="/">
              <img src="~src/pictures/eshelf_logo_black.png" width="80">
            </a>
            <div v-if="showFullHeader" class="navbar-elements d-flex justify-content-end align-items-center">
              <div class="searchbar w-100 px-5 d-none d-md-flex">
                <filter-text-search ref="filterTextSearch" v-on:update-text-search-filter="updateTextSearch($event)" ></filter-text-search>
              </div>
              <div class="action-elements d-flex align-items-center justify-content-center">
                <a class="text-black pr-4" href="/shopping_cart">
                  <i class="fas fa-shopping-cart position-relative">
                    <span v-if="basketProductsNumber" class="px-1 position-absolute product-badge text-white d-flex align-items-center justify-content-center">
                      <div>{{basketProductsNumber }}</div>
                    </span>
                  </i>
                </a>
                <template v-if="userInfo">
                  <div @click="toggleMenu()" class="text-black mw-20 cursor-pointer"><i id="hbMenu" class="fas fa-bars"></i></div>
                  <nav class="user-menu position-absolute bg-white border-top" id="menuPanel">
                    <ul class="py-3 px-0 my-0">
                      <li class="px-3 pb-3 border-bottom">{{userInfo.email}}</li>
                      <li class="px-3 pt-3">
                        <a class="user-menu-item" :class="{'active': isItemActive('/users/my_orders')}" href="/users/my_orders">My orders</a>
                      </li>
                      <li class="px-3 pt-3">
                        <a class="user-menu-item" href="/users/sign_out">Log out</a>
                      </li>
                    </ul>
                  </nav>
                </template>
                <template v-else>
                  <a class="text-black" href="/users/sign_in" >Login</a>
                </template>
              </div>
            </div>
          </nav>
        </div>
        <div v-if="showFullHeader" class="col-12 pb-3 d-md-none">
           <filter-text-search ref="filterTextSearch" v-on:update-text-search-filter="updateTextSearch($event)" ></filter-text-search>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

  .mw-20 {
    min-width: 20px;
  }
  .product-badge {
    min-width: 16px;
    height: 16px;
    bottom: -7px;
    right: -7px;
    background-color: red;
    border-radius: 25%;
    font-size: 12px;
  }
  .navbar-elements {
    flex: 1;
  }

 .action-elements {
   i {
     font-size: 1.25rem;
   }
  }

  .user-menu {
    transition: all 0.4s;
    opacity: 0;
    visibility: hidden;
    right: 4px;
    top: 100%;
    z-index: 1021;
    min-width: 200px;
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
    
    &.show-menu {
      visibility: visible;
      opacity: 1;
    }

    li {
     display: block;
    }

    .user-menu-item {
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

</style>
