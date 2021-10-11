<script>
import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  mixins: [applicationMixin],
  props: ["error-message", "error-items"],
  data() {
    return {
      globalState: globalState,
    }
  },
  mounted() {
    if (this.errorMessage || this.errorItems) {
      Vue.set(globalState, "errors", {
        message: !!this.errorMessage ? this.errorMessage : '',
        items: !!this.errorItems ? this.errorItems : []
      });
    }
  },
  computed: {
    items() {
      return (typeof globalState.errors.items == "string") ? [globalState.errors.items] : globalState.errors.items;
    }
  }
}
</script>

<template>
  <div v-if="!!globalState.errors">
    <div class="alert alert-danger alert-dismissible fade show" id="error_explanation">
      <button type="button" class="close" data-dismiss="alert">&times;</button>
      <strong>
        {{globalState.errors.message}}
      </strong>
      <ul>
        <li v-for="(message, index) in items" :key="`error-number-${index+1}`">{{ message }}</li>
      </ul>
    </div>
  </div>
</template>