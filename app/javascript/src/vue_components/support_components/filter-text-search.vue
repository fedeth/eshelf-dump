<script>
import { applicationMixin } from "src/modules/application_mixin.js";
import { searchMixin } from "src/modules/search_mixin.js";
import { debounce, get } from "lodash";

export default {
  mixins: [applicationMixin, searchMixin],

  mounted: function() {
    Vue.nextTick(() => {
      $(this.$refs["searchTextField"]).keyup(debounce(this.getProductsSuggestions, 700));
    });
  },
  data: function () {
    return {
      suggestions: null,
    }
  },
  computed: {
    searchText: {
      get(){
        return this.pageModel.search_params.search_text;
      },
      set(newText){
        Vue.set(this.pageModel.search_params, "search_text", newText);
      }
    },
  },
  methods:{
    getProductsSuggestions() {
      ApplicationModule.ajaxGet({
        url: "/api/v1/products/suggestions",
        data: {
          search_text: this.searchText,
        },
        success: (data) => {
          Vue.set(this, "suggestions", data.suggestions);
        },
        error: (err) => {
          console.error(err);
        }
      });
    },
    updateTextSearch() {
      if(this.searchText != null){
        const searchUrl = `/search?search_text=${this.searchText}`;
        window.location.href = encodeURI(searchUrl);
      } else {
        window.location.href = "/search";
      }
    },
  },
}
</script>

<template>
  <div class="w-100">
    <div class="input-group">
      <input
        type="text"
        class="form-control"
        v-model="searchText"
        ref="searchTextField"
        list="suggestions-list"
        placeholder="Search..."
        v-on:keyup.enter="updateTextSearch()"
      >
      <div class="input-group-append">
        <button
          class="btn btn-outline-dark"
          @click="updateTextSearch()"
          type="button"
        ><i class="fas fa-search"></i></button>
      </div>
    </div>

    <datalist id="suggestions-list" v-if="!!suggestions && !!searchText">
      <option v-for="(suggestion, index) in suggestions" :key="`suggestion-${index}`" :value="suggestion">{{suggestion}}</option>
    </datalist>

  </div>
    
</template>

<style lang="scss" scoped>
  .input-group {
    input[type="text"] {
      background-color: $light-grey;
    }
  }
</style>
