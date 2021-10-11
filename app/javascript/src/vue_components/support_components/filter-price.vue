<script>
import { applicationMixin } from "src/modules/application_mixin.js";
import { debounce, get } from "lodash";
// https://nightcatsama.github.io/vue-slider-component

export default {
  mixins: [applicationMixin],
  data: function () {
    return {
      reset: false,
      range: [get(globalState.pageModel, ["search_params", "price_range", 0], 1),get(globalState.pageModel, ["search_params", "price_range", 1], 999)]
    }
  },
  methods:{
    updatePriceFromSlider: function() { 
      let cmp = this;
      let priceRange = this.$refs.priceSlider.getValue();
      Vue.set(this, "range", priceRange);
      if(this.reset){
        this.reset = false;
      } else {
        this.emitEvent(cmp, priceRange);
      }
    },
    emitEvent: debounce((cmp, priceRange) => {cmp.$emit("update-price-filter", priceRange)}, 250),   
    updatePriceFromFields(){
      let minPrice = Number.isNaN(parseInt(this.range[0],10)) ? 1 : parseInt(this.range[0],10);
      let maxPrice = Number.isNaN(parseInt(this.range[1],10)) ? 1 : parseInt(this.range[1],10);
      this.$refs.priceSlider.setValue([minPrice,maxPrice]);
    },
  },
  computed: { }
}
</script>

<template>
  <div filter-price>
    <div><h5>Price</h5></div>
    <vue-slider
      v-model="range"
      class="pr-3"
      ref="priceSlider"
      @change="() => updatePriceFromSlider()"
      :enable-cross="false"
      :min="1"
      :max="999"
    >
    </vue-slider>
    <div class="d-flex align-items-center pt-3">
      <span class="pr-2">from: </span><input type="number" class="price-box" min="1" max="998" v-model="range[0]" @change="updatePriceFromFields()" />
      <span class="px-2">to: </span><input type="number" class="price-box" min="2" max="999" v-model="range[1]" @change="updatePriceFromFields()" />
    </div>
  </div>
</template>

<style lang="scss">
  [filter-price] {
    .vue-slider-process {
      background-color: black;
    }
    .price-box{
      width: 64px;
    }
  }
</style>
