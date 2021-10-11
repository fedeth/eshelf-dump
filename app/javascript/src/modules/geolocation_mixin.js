const get = require('lodash.get');

const geolocationMixin = {
  data: function() {
    return {
      postcode: null,
      coords: null,
      errors: null, // is too generic this name
      geoLocationErrors: [],
      currentLocationAvailable: null,
    }
  },
  mounted() {
    // test geolocation, we need fallback when NOT available.
    if ("geolocation" in navigator) {
      console.log("geolocation is available");
      this.currentLocationAvailable = true;
    } else {
      console.warn("geolocation is NOT available");
      this.currentLocationAvailable = false;
    }
    this.initLocationData();
  },
  methods: {
    initLocationData() {
      this.postcode = get(globalState.pageModel, ['geolocation_info', 'postcode'], null);
      this.coords = get(globalState.pageModel, ['geolocation_info', 'coords'], null);
    },
    setPosition({successRedirectUrl, coords_only}) {
      const params = {}
      this.getLocationErrors = [];
      if (this.postcode && !coords_only) {
        params.postcode = this.postcode;
      }
      if (this.coords) {
        params.coords = this.coords;
      }
      ApplicationModule.postDataForm({
        url: "/api/v1/set_geolocation",
        data: params,
        success: (data) => {
          if (data.status === 'ok') {
            console.log("set_geolocation", data);
            if (data.postcode) {
              Vue.set(globalState.pageModel.geolocation_info, 'postcode', data.postcode);
            }
            if (data.coords) {
              Vue.set(globalState.pageModel.geolocation_info, 'coords', data.coords);
            }
            this.initLocationData();
            this.errors = null;
            if (!!successRedirectUrl) {
              window.location.href = successRedirectUrl;
            } else {
              this.$emit('position-updated');
            }
          } else if(data.error) {
            Vue.set(this, 'geoLocationErrors',  data.error.details);
          }  
        },
        error: (err) => {
          console.error(err);
          this.errors = err.responseJSON;
          this.initLocationData();
        }
      });
    },
    getCurrentLocation(successRedirectUrl) {
      const geo_success = (position) => {
        this.coords = {
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        };
        this.setPosition({successRedirectUrl, coords_only: true});
      }
      const geo_error = () => {
        alert("Sorry, no position available.");
      }
      const geo_options = {
        enableHighAccuracy: true,
        maximumAge: 31000,
        timeout: 5000
      };
      navigator.geolocation.getCurrentPosition(geo_success, geo_error, geo_options);
    }
  }
}

export {
  geolocationMixin
};