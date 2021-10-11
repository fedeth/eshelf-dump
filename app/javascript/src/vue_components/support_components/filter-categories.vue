<script>
import { applicationMixin } from "src/modules/application_mixin.js";
import { cloneDeep } from 'lodash';

export default {
  props: {
    filteringCategories: {
      type: Object,
      default: () => {}
    }
  },
  mixins: [applicationMixin],
  data() {
    return { }
  },
  methods:{
    toggleCategoryFilter(id, categoryName) {
      let categories = cloneDeep(this.filteringCategories);
      let parsedId = parseInt(id, 10);
      if(categories[parsedId]) {
        delete categories[parsedId];
      } else {
        categories[id] = categoryName;
      }
      this.$emit("update-categories-filter", Object.values(categories));
    },
    collapseCategory(categoryId){
      let find = false
        Object.keys(this.filteringCategories).forEach(childCategoryId => {
        if(this.pageModel.categories[childCategoryId].parent_id == categoryId) {
          find = true;
        }
      });
      return find ? "show" : null;
    }
  },
  computed: {
    // Avoid to bind with v-model props directly
    
    checkboxCategories: {
      get(){
        return Object.keys(this.filteringCategories);
      },
      set(_filteringCategories){
        //strange behaviour: checkboxCategories only watchs filteringCategories prop, so setter is useless, but Vue looking for a setter aniway. Omit setter raise warnings in console.
        // checkbox's v-model is involved in this issue.
      }
      
    },
  }
}
</script>

<template>
  <div class="categories-filter">
    <h4>Categories</h4>
    
    <div v-for="category in orderedCategories" v-bind:key="`category-${category.id}`">
      <template v-if="category.children">
        <div class="d-flex">
          <a
            class="pl-2 text-dark cursor-pointer py-1"
            role="button"
            data-toggle="collapse"
            :data-target="`#collapse-${category.id}`"
            aria-expanded="true"
            :aria-controls="`collapse-${category.id}`"
          >
            <b>{{category.title}} </b><i class="fas fa-caret-down"></i>
          </a>
        </div>
        <div :id="`collapse-${category.id}`" class="collapse" :class="collapseCategory(category.id)">
          <div v-for="childCategory in category.children" class="py-1" :key="`children-category-${childCategory.id}`">
            <div 
              class="form-check ml-3 pretty p-default"
              @change="toggleCategoryFilter(childCategory.id, childCategory.name)" 
            >
              <input 
                class="form-check-input"
                type="checkbox"
                :value="childCategory.id"
                v-model="checkboxCategories"
                :id="`sub-cat${childCategory.id}`">
                <div class="state p-primary">
                  <label class="form-check-label cursor-pointer" :for="`sub-cat${childCategory.id}`">
                    {{childCategory.title}}
                  </label>
                </div>
            </div>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .selected-category {
    font-weight: bold;
  }

  .pretty .state label {
    text-indent: 0.5rem;
  }

  .cursor-pointer {
    cursor: pointer;
    &:hover {
      color: $dark-grey;
    }
  }

</style>
