import { ApplicationModule } from "src/modules/application_module.js";
import { cloneDeep } from 'lodash';

const searchMixin = {
  props: {},
  mixins: [],
  data() {
    return { };
  },
  computed: {
    searchParams() {
      return globalState.pageModel.search_params;
    },
  },
  mounted() {
    const searchParams = new URLSearchParams(window.location.href);
    Object.keys(searchParams).forEach((key) => {
      Vue.set(globalState.pageModel.search_params, key, searchParams[key]);
    })
  },
  methods: {
    setProducts(data){
      this.pageModel.search_results.number_of_pages = data.number_of_pages;
      Vue.set(this.pageModel.search_results, "products", data.products);
      Vue.set(this.pageModel, "search_params", data.search_params);
      Vue.nextTick(() => {
        this.loading = false;
      });
    },
    getSearchedProducts(changingPage) {
      const params = cloneDeep(this.searchParams);
      this.loading = true;

      if (!changingPage) {
        delete params.page_number;
      }
      
      ApplicationModule.ajaxGet({
        url: "/api/v1/products/search",
        data: params,
        success: (data) => {
          const baseUrl = window.location.origin + window.location.pathname + "?";
          this.setProducts(data);
          history.pushState('', '', baseUrl + $.param(globalState.pageModel.search_params));
        },
        error: (err) => {
          console.log(err);
        }
      });
    },
  }
};

export {
  searchMixin,
};
