import { ApplicationModule } from "src/modules/application_module.js";

const snakeCase = require('lodash.snakecase');
const camelCase = require('lodash.camelcase');
const cloneDeep = require('lodash.clonedeep');
const get = require('lodash.get');

const applicationMixin = {
  props: {},
  mixins: [],
  data() {
    return {
      pageModel: globalState.pageModel,
    };
  },
  computed: {
    orderedCategories() {
      let categoriesTree = {};
      for (let [key, value] of Object.entries(this.pageModel.categories)) {
        if(value.parent_id) {
          categoriesTree[value.parent_id] = categoriesTree[value.parent_id] || {};
          categoriesTree[value.parent_id]["children"] = categoriesTree[value.parent_id]["children"] || {};
          categoriesTree[value.parent_id]["children"][value.id] = value;
        } else {
          categoriesTree[key] = categoriesTree[key] ? {...categoriesTree[key], ...value} : value;
        }
      }
      return categoriesTree;
    },
  },
  methods: {
    cloneDeep: cloneDeep,
    snakeCase: snakeCase,
    camelCase: camelCase,
    get: get,
    setAll: function(obj, val) {
      Object.keys(obj).forEach(function(index) {
          obj[index] = val
      })
    },
    setAllToNull: function(obj) {
      this.setAll(obj, null);
    },
    generateGTMProducts(products){
      let gtmProducts = [];
      products.forEach((product) => {
        gtmProducts.push({
          'name': product.title,
          'id': product.id,
          'price': (product.price / 100),
          'brand': product.brand,
          'category': this.pageModel.categories[product.category_id].title,
          'quantity': product.quantity,
        });
      });
      return gtmProducts;
    },
    generateGTMImpressionProducts(products, listName = "Search Results"){
      let gtmImpressionProducts = [];
      products.forEach((product, index) => {
        gtmImpressionProducts.push({
          'name': product.title,
          'id': product.id,
          'price': (product.price / 100),
          'brand': product.brand,
          'category': this.pageModel.categories[product.category_id].title,
          'list': listName,
          'position': index + 1,
        });
      });
      return gtmImpressionProducts;
    }
  }
};

export {
  applicationMixin,
};
