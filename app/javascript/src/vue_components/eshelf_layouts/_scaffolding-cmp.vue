<script>

// import { applicationMixin } from "src/modules/application_mixin.js";
// import { fooBar } from 'lodash';

export default {
  props: ['vueContent'],
  // mixins: [applicationMixin],
  mounted: function() {
    console.log("component mounted");
  },
  data: function () {
    return {
      content: this.vueContent,
    }
  },
  methods:{
    fooBarMethod: function() { },
  },
  computed: {
    fooBarComputed: function(){
      return "foobar";
    }
  }
}
</script>

<template>
  <div class="container">
    <div class="row">
      <div class="col-12">
        <h1>Scaffolding component</h1>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

</style>
