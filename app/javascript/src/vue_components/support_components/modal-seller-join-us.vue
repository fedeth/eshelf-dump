<script>

import { applicationMixin } from "src/modules/application_mixin.js";
import { recaptchaV3Mixin } from "src/modules/recaptcha_v3_module.js";

export default {
  props: ['openModalSignal'],
  mixins: [applicationMixin, recaptchaV3Mixin],
  mounted: function() {
    $('#joinUsModal').on('hide.bs.modal', (event) => {
      this.$emit("close-modal");
      Vue.set(this, "errors", []);
      Vue.set(this, "formData", {});
    });
  },
  data: function () {
    return {
      isLoading: false,
      formSubmitted: false,
      errors: [],
      formData: {}
    }
  },
  methods:{
    submitForm(){
      this.isLoading = true;

      let callSubmitApi = () => {
        ApplicationModule.postDataForm({
          url: "/api/v1/submissions/submit_seller_info",
          data: this.formData,
          success: (data) => {
            console.log("submitForm", data);
            if(data.success) {
              Vue.set(this, "errors", []);
              this.formSubmitted = true;
            } else {
              Vue.set(this, "errors", data.errors);
            }
            this.isLoading = false;
          }
        });
      };

      if(this.recaptchaIsActive()){
        this.createRecaptchaToken("sellerInfoForm");
        this.waitForRecaptchaToken(1000, "sellerInfoForm", () => {
          let sellerInfoFormToken = globalState.pageModel.recaptcha_v3["sellerInfoForm"];
          Vue.set(this.formData, "recaptcha_v3_token", sellerInfoFormToken);
          callSubmitApi();
        });
      } else {
        callSubmitApi();
      }
    },
    closeModal(){
      this.$emit("close-modal");
    },
  },
  watch: {
    openModalSignal: function (signal) {
      if(signal == true){
        $('#joinUsModal').modal('show');
      } 
    }
  }
}
</script>

<template>
<!-- Modal -->
<div class="modal fade" id="joinUsModal" tabindex="-1" role="dialog" aria-labelledby="joinUsModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header border-0">
        <h3 class="modal-title" id="joinUsModalLabel">{{formSubmitted ? "Thanks for your application" : "Partner application"}}</h3>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="container-fluid">
          <div class="form-wrapper position-relative">
            <template v-if="!formSubmitted">
              <form id="sellerInfoForm" @submit.prevent="submitForm()">
                <div class="row">
                  <input type='hidden' :value="formData.recaptcha_v3_token" >
                  <div class="col-6 form-group">
                    <label>First Name*</label>
                    <input v-model="formData.firstName" class="form-control" type="text" required >
                  </div>
                  <div class="col-6 form-group">
                    <label>Last Name*</label>
                    <input v-model="formData.lastName" class="form-control" type="text" required >
                  </div>
                  <div class="col-12 form-group">
                    <label>Company Name*</label>
                    <input v-model="formData.companyName" class="form-control" type="text" required >
                  </div>
                  <div class="col-6 form-group">
                    <label>Email*</label>
                    <input v-model="formData.emailAddress" class="form-control" type="text" required >
                  </div>
                  <div class="col-6 form-group">
                    <label>Phone*</label>
                    <input v-model="formData.phoneNumber" class="form-control" type="text" required >
                  </div>
                  <div class="col-12 form-group">
                    <label>Website URL</label>
                    <input v-model="formData.websiteUrl" class="form-control" type="text">
                  </div>
                  <div class="col-12 form-group">
                    <label>Main Social Media URL</label>
                    <input v-model="formData.socialMediaUrl" class="form-control" type="text">
                  </div>
                  <div class="col-12">
                    <div v-if="errors.length > 0" class="alert alert-danger mt-2" role="alert">
                      <h6>Please check that your data is correct and try again:</h6>
                      <ul>
                        <li v-for="error in errors" :key="error">{{error}}</li>
                      </ul>
                    </div>
                  </div>
                  <div class="col-12 py-4">
                    <button type="submit" class="btn btn-dark w-100" :disabled="isLoading" >Apply</button>
                  </div>
                </div>
              </form>
            </template>
            <template v-else>
              <div class="success-message flex-column d-flex align-items-center justify-content-center">
                <i class="py-3 far fa-check-circle"></i>
                <h4 class="py-4">Our team will review your shop profile and get in touch soon.</h4>
                <button type="button" class="btn btn-dark w-100 mb-4" data-dismiss="modal">Close</button>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<style lang="scss" scoped>

.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
}

.form-wrapper {
  transition: all 1s;
}

.success-message {
  background-color: #fff;
  
  i {
    font-size: 7rem;
    color: $green;
  }
}


</style>
