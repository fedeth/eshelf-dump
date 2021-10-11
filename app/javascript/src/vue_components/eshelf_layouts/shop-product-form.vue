<script>
import { ApplicationModule } from "src/modules/application_module.js";
import { applicationMixin } from "src/modules/application_mixin.js";
// import { fooBar } from 'lodash';

export default {
  props: ['vueContent', 'action'],
  mixins: [applicationMixin],
  mounted: function() {
  // This prevents the page from scrolling down to where it was previously.
    if ('scrollRestoration' in history) {
        history.scrollRestoration = 'manual';
    }
    if(this.action == "edit") {
      this.productId = this.vueContent.current_product_data["id"];
      const productDataToSet = ["title", "price", "brand", "keywords", "specs", "description", "category_id", "quantity"];
      productDataToSet.forEach((attr) => {
        Vue.set(this.productData, attr, this.vueContent.current_product_data[attr]);
      })
      this.parentCategoryId = this.vueContent.current_product_data["parent_category_id"];
      this.fileUrl = this.vueContent.current_product_data["image_link"];
    }
  },
  data: function () {
    return {
      productId: null,
      fileUrl: null,
      parentCategoryId: null,
      submitInProgress: false,
      productData: { },
      errors: []
    }
  },
  methods:{
    onFileChange(e) {
      const file = e.target.files[0];
      if(file) {
        this.fileUrl = URL.createObjectURL(file);
        Vue.set(this.productData, "file", file);
      }
    },
    resetChildrenCategory: function(e) {
      Vue.set(this.productData, 'category_id', null);
    },
    performAction: function() {
      switch (this.action) {
        case "new":
          this.createProduct();
          break;
        case "edit":
          this.editProduct();
          break;
      }
    },
    createProduct: function() {
      this.submitInProgress = true;
      ApplicationModule.postDataForm({
        url: "/api/v1/create_product/",
        data: this.productData,
        success: (data) => {
          if(data.success){
            window.location.href = "/shops/my_shop/products";
          }
          else if(data.errors.length > 0) {
            console.log("errors", data.errors);
            Vue.set(this, "errors", data.errors);
            window.scrollTo(0,0);
            this.submitInProgress = false;
          }
        }
      });
    },
    editProduct:function() {
      this.submitInProgress = true;
      ApplicationModule.postDataForm({
        url: `/api/v1/update_product/${this.productId}`,
        data: this.productData,
        success: (data) => {
          if(data.success){
            window.location.href = "/shops/my_shop/products";
          }
          else if(data.errors.length > 0) {
            console.log("errors", data.errors);
            Vue.set(this, "errors", data.errors);
            window.scrollTo(0,0);
            this.submitInProgress = false;
          }
        }
      });
    },
    deleteProduct:function() {
       ApplicationModule.ajax({
        url: `/api/v1/delete_product/${this.productId}`,
        success: (data) => {
          if(data.success){
            window.location.href = "/shops/my_shop/products";
          }
        }
      });
    },
  },
  computed: {
    fileName: function() {
      let fileName = this.action == "edit" ? "Change product image" : "Upload product image";
      if(this.productData.file) {
        fileName = this.productData.file.name;
      }
      return fileName
    },
    subCategories: function(){
      let subCategories = {};
      if(this.parentCategoryId) {
        subCategories = this.orderedCategories[this.parentCategoryId].children;
      }
      return subCategories;
    },
    pageTitle: function() {
      return this.action == "edit" ? this.vueContent.current_product_data["title"] : "Add product";
    }
  }
}
</script>

<template>

    <div class="container-fluid py-4">
      <div class="row">
        <div class="col-12 pb-3">
          <div class="py-3 d-flex align-items-center"><i class="fas fa-angle-left pr-2"></i>
          <a href="/shops/my_shop/products" class="text-dark">All products</a>
          </div>
          <h2>{{pageTitle}}</h2>
        </div>
      </div>
      <form id="newProductForm" @submit.prevent="performAction()">
        <div id="formErrors" v-if="errors.length > 0" class="row px-md-0 py-0 ">
          <div class="col-12 px-md-0">
            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
              There are some errors in your submission:
              <ul class="mt-2 mb-3">
                <li v-for="(error, index) in errors" :key="`errror-${index}`" >{{error}}</li>
              </ul>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
          </div>
        </div>
        <div class="row px-md-4 py-5 bg-white form-vital-info box-shadow">
          <div class="col-6 form-group">
            <label>Model</label>
            <input v-model="productData.title" @keydown.enter.prevent class="form-control" id="productTitle" type="text" required >
          </div>
          <div class="col-6 form-group">
            <label>Brand</label>
            <input v-model="productData.brand" @keydown.enter.prevent class="form-control" type="text" required >
          </div>
          <div class="col-6 form-group">
            <label for="mainCategory">Category:</label>
            <select id="mainCategory" v-model="parentCategoryId" @change="resetChildrenCategory()" class="form-control" required>
              <option disabled :value="null">Choose...</option>
              <option v-for="category in orderedCategories" :value="category.id" :key="`category-${category.id}`">{{category.title}}</option>
            </select>
          </div>
          <div class="col-6 form-group">
            <label for="category">Sub category:</label>
            <select id="category" v-model="productData.category_id" :disabled="!parentCategoryId" class="form-control" required>
              <option disabled :value="undefined || null">Choose...</option>
              <option v-for="category in subCategories" :value="category.id" :key="`category-${category.id}`">{{category.title}}</option>
            </select>
          </div>
          <div class="col-12 form-group">
            <label for="formDescription">Description</label>
            <textarea v-model="productData.description"  maxlength="1500" class="form-control" id="formDescription" rows="5" required></textarea>
          </div>
          <div class="col-12 form-group">
            <label for="formDetails">Additional details</label>
            <textarea v-model="productData.specs" maxlength="1000" class="form-control" id="formDetails" rows="3" required></textarea>
          </div>
        </div>
        <div class="row my-3 px-md-4 bg-white form-picture-upload box-shadow">
          <div class="col-12 col-md-6 py-md-5 py-3 d-flex align-items-center form-group">
            <div class="custom-file">
              <input type="file" @change="onFileChange" class="custom-file-input" id="customFile" :required="!(action == 'edit')">
              <label class="custom-file-label" for="customFile">{{fileName}}</label>
            </div>
          </div>
          <div class="col-12 col-md-6 py-3 align-items-center justify-content-center d-flex form-group">
            <div v-if="fileUrl" class="d-flex aling-items-center justify-content-center" id="preview">
              <img :src="fileUrl" class="img-fluid mh-125px"/>
            </div>
          </div>
        </div>
        <div class="row px-md-4 py-5 bg-white form-additional-info box-shadow">
          <div class="col-6 form-group">
            <label>Price</label>
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text" id="pricePrepend">£</span>
              </div>
              <input v-model="productData.price" @keydown.enter.prevent class="form-control" type="number" min="1.00" max="10000.00" step="0.01" placeholder="0.00" required >
            </div>
          </div>
          <div class="col-6 form-group">
            <label>Quantity</label>
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text" id="quantityPrepend">PCs in stock:</span>
              </div>
              <input v-model="productData.quantity" @keydown.enter.prevent class="form-control" pattern="\d*" type="number" step="1" min="0" max="50" required >
            </div>
          </div>
          <div class="col-12 form-group" @keydown.enter.stop>
            <label>Keywords:</label>
            <textarea v-model="productData.keywords" @keydown.enter.prevent class="form-control" pattern="^[a-zA-Z, ]*$" placeholder="alphabetic characters only, comma separated. Eg: wood, fashion, style" type="text" rows="2" maxlength="200"  ></textarea>
          </div>
        </div>
        <div class="row px-md-0 py-5 form-actions">
          <div class="col-12 px-md-0 d-flex justify-content-between">
            <div>
              <button v-if="action == 'edit'" type="button" data-toggle="modal" data-target="#deleteProductModal" class="btn btn-red-alert px-5">DELETE</button>
            </div>
            <div>
              <button type="submit" :disabled="submitInProgress" class="btn btn-dark px-5 btn-mw">SAVE</button>
            </div>
          </div>
        </div>
      </form>
      <div v-if="action == 'edit'" class="modal fade" id="deleteProductModal" tabindex="-1" role="dialog" aria-labelledby="deleteProductModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
          <div class="modal-content border-0">
            <div class="modal-header">
              <h5 class="modal-title">Delete {{vueContent.current_product_data.title}}?</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <p>Are you sure you want to delete product <b>{{vueContent.current_product_data.title}}</b>? This can't be undone.</p>
            </div>
            <div class="modal-footer d-flex justify-content-between">
              <div><button type="button" class="btn btn-light" data-dismiss="modal">Cancel</button></div>
              <div><button type="button" class="btn btn-red-alert" @click="deleteProduct()">Delete product</button></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  
</template>

<style lang="scss" scoped>

  //.form-additional-info, .form-vital-info, .form-picture-upload  {}

  .btn-mw {
    @include media-breakpoint-up(md) {
      min-width: 16rem;
    }
    
  }

  .mh-125px {
    max-height: 125px;
  }

</style>
