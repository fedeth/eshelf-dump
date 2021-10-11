<script>
import { applicationMixin } from "src/modules/application_mixin.js";
import { geolocationMixin } from "src/modules/geolocation_mixin.js";

export default {
  mixins: [applicationMixin, geolocationMixin],
  props: ["dropdownMenuPosition"],
  computed: {
    dropdownMenuClasses() {
      const classes = []
      if (this.dropdownMenuPosition) {
        classes.push(`dropdown-menu-${this.dropdownMenuPosition}`);
      }
      return classes;
    }
  }
}
</script>

<template>
  <div>
    <small><i class="fas fa-map-marker-alt"></i> Products in </small>
    <div class="d-flex">
      <small class="text-primary">{{pageModel.geolocation_info.postcode || 'not provided'}}</small>
      <div class="dropdown">
        <button class="dropdown-toggle ml-2" type="button" data-toggle="dropdown"></button>
        <div class="dropdown-menu border-radius-0 p-3" :class="dropdownMenuClasses">
          <div class="form-group w-100 mb-0">
            <label><small><b>Change your location</b></small></label>
            <div class="input-group">
              <input v-model="postcode" type="text" placeholder="e.g. W1J 9HS" class="form-control">
              <div class="input-group-append">
                <button class="btn btn-outline-dark" type="button" @click.stop="setPosition({})">
                  <i class="fas fa-arrow-right"></i>
                </button>
              </div>
            </div>
            <div class="separator w-100 d-flex justify-content-center align-items-center my-3" v-if="currentLocationAvailable">
              <div class="separator-label bg-white p-1">or</div>
            </div>
            <button class="btn btn-primary w-100" type="button" @click.stop="getCurrentLocation()" v-if="currentLocationAvailable">
              Use current location
            </button>
            <p class="small text-danger mt-3 mb-0" v-if="!!errors"><strong>{{errors.title}}</strong><br/>{{errors.details}}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
  .dropdown-toggle {
    border: 0;
    background-color: unset;
  }

  .input-group {
    flex-wrap: nowrap;
  }

  .dropdown-menu {
    border: 1px solid #D0D0D0;
    box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.25);
  }

  .separator {
    height: 1px;
    background-color: #D0D0D0;

    .separator-label {
      line-height: 1rem;
    }
  }

  .dropdown-menu,
  input[type=text] {
    border-radius: 0;
  }

  .text-danger {
    line-height: 1rem;
  }

  input[type=text] {
    min-width: 10rem;
  }
</style>