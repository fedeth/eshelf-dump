<script>

//import { applicationMixin } from "src/modules/application_mixin.js";
import { disableBodyScroll, clearAllBodyScrollLocks } from 'body-scroll-lock';

export default {
  props: ['menuLinks'],
  //mixins: [applicationMixin],
  mounted() {
    Vue.nextTick(() => {
      disableBodyScroll(this.$el);
    });
  },
  beforeDestroy() {
    clearAllBodyScrollLocks();
  },
  data: function () {
    return {
      foo: { bar: 1},
    }
  },
}
</script>

<template>
  <div class="position-fixed" header-sidebar>
    <div class="position-absolute h-100 w-100 bg-light-grey"> 
      <div class="pl-3 bg-white d-flex align-items-center w-100 border-bottom shop-name-container position-relative">
        Company Name
      </div>
      <div class="close-icon position-absolute" @click="$emit('sidebar-close')">
        <i class="fas fa-times"></i>
      </div>
      <div class="px-3 py-2 w-100 position-relative">
        <ul class="py-3 pl-0">
          <li v-for="menuLink in menuLinks" :key="`${menuLink[0]}`" class="menu-link d-block py-2">
            <div class="pr-2 icon-menu-container d-inline-block">
              <i :class="menuLink[2]"></i>
            </div>
            <a  class="text-black" :href="menuLink[1]">{{menuLink[0]}}</a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

[header-sidebar] {
  min-height: 100vh;
  z-index: 15;
  top: 0;
  width: 80vw;
  overflow-y: scroll;
  -webkit-overflow-scrolling: touch;

  .icon-menu-container{
    width: 2.5rem;
    font-size: 1.25rem;;
    i {
      font-size: 1.5rem;
    }
  }

  .menu-link {

    font-size: 1.5rem;
  }

  .shop-name-container {
    top:0;
    right: 0;
    height: 3rem;
  }

  .close-icon {
    font-size: 1.5rem;
    opacity: .85;
    line-height: .85rem;
    right: 1rem;
    top: .75rem;
  }
}

</style>
