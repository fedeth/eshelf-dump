<script>

import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  props: ['vueContent'],
  mixins: [applicationMixin],
  mounted: function() {},
  data: function () {
    return {
      content: this.vueContent,
    }
  },
  methods:{
   
  },
  computed: {
    
  }
}
</script>

<template>
  <div class="w-100 h-100 collection-tile border d-flex flex-column">
    <div class="collection-tile__header-wrapper position-relative">
      <div class="header-container fill-wrapper bg-std-grey d-flex align-items-end">
        <div class="w-100 d-flex px-3 py-2">
          <div class="avatar bg-light-grey"></div>
          <div class="curator-info text-white d-flex align-items-center pl-3 font-md"> Lorem Ipsum</div>
        </div>
      </div>
    </div>
    <div class="collection-tile__content-wrapper d-flex flex-column flex-grow-1">
      <div class="content-container flex-grow-1">
        <div class="tile-title pt-4 pb-3 px-4">
          <h4 class="text-center">Classic Decor British<br>velvet style</h4>
        </div>
        <div class="tile-description font-md px-4 pb-3 text-center">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
        </div>
      </div>
      <div class="tile-button text-center pt-4 pb-3">
        <a role="button" class="btn btn-dark px-5 py-2" href="/collections/example">DISCOVER MORE</a>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

  .collection-tile {
    position: relative;
  }

  .collection-tile__header-wrapper {
    padding-top: 68.5%;
   
    .header-container {
      .avatar {
        height: 60px;
        width: 60px;
        border-radius: 50%;
     }

      .curator-info {
       font-weight: 500;
      }
    }
  }
 
  .collection-tile__content-wrapper {
    .content-container {
      .tile-title {
        
      }
    }
  }

</style>
