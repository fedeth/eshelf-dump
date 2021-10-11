<script>

import { applicationMixin } from "src/modules/application_mixin.js";

export default {
  props: { },
  mixins: [applicationMixin],
  data: function () {
    return {
      shopInfo: globalState.pageModel.shop_info,
      shopUpdateInfoForm: {
        address: null,
        city: null,
        company_number: null,
        contact_person_first_name: null,
        contact_person_last_name: null,
        contact_person_role: null,
        phone_number: null,
        postcode: null,
        trading_name: null,
      },
      shopAvatar: {},
    }
  },
  mounted() { },
  computed: {},
  methods: {
    prepareFileToUpload(obj) {
      const formData = new FormData();
      formData.append("file", obj);
      return formData;
    },
    setShopAvatar() {
      Vue.set(this, "shopAvatar", this.$refs.shopAvatar.files[0]);
    },
    updateShopAvatar(){
      ApplicationModule.postDataForm({
        url: "/api/v1/update_shop_avatar",
        data: {file: this.shopAvatar},
        success: (data) => {
          Vue.set(this.shopInfo, "shop_avatar", data.attachment_url);
        }
      });
    },
    updateShopInfo() {
      ApplicationModule.postDataForm({
        url: "/api/v1/update_shop_info",
        data: ApplicationModule.removeNullProperties(this.shopUpdateInfoForm),
        success: (data) => {
          for (const [key, value] of Object.entries(data)) {
            Vue.set(this.shopInfo, key, value);
          }
        },
      });
    }
  },
}
</script>

<template>
  <div class="container ohidden">
    <div class="row pb-5">
      <div class="col-12">
        <h1>Shop info</h1>
      </div>
      <div class="col-6">
        <form v-on:submit.prevent="updateShopInfo()">
          <div v-for="field in Object.keys(shopUpdateInfoForm)" class="form-group w-100">
            <label class="mb-1" :for="field">{{snakeCase(field)}}</label>
            <input type="text" class="form-control form-control-sm w-75" :id="field" :key="field" :name="snakeCase(field)" :placeholder="shopInfo[field]" v-model="shopUpdateInfoForm[field]">
          </div>
          <input value="Update info" type="submit">
        </form>
      </div>
      <div class="col-6">
        <div class="row">
          <div class="col-12 d-flex">
            <div class="d-flex w-50">
              <img class="img-fluid" :src="shopInfo.shop_avatar">
            </div>
          </div>
          <div class="col-12 py-4">
            <form v-on:submit.prevent="updateShopAvatar()">
              <input type="file" ref="shopAvatar" v-on:change="setShopAvatar()">
              <input value="Update avatar" type="submit">
            </form>
          </div>
          <div class="col-12">
            <ul>
              <li v-for="(value, fieldName) in shopInfo">
                <b>{{fieldName}}: </b>{{value}}</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

.ohidden {
  overflow: hidden;
}
  
</style>