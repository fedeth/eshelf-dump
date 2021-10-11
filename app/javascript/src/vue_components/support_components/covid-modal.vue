<script>
const C_NAME = "_fedeshelf_covid_19_modal_cookie"

export default {
  mounted() {
    const cookie = ApplicationModule.readCookie(C_NAME);
    if (!cookie) {
      setTimeout(() => {
        $("#covidModal").modal('show');
      }, 3000);
    }
  },
  methods: {
    linkClickHandler() {
      this.setModalCookie();
      window.location.href = "/covid_19_services";
    },
    setModalCookie() {
      const time = (new Date()).getTime() + 24*60*60*1000;
      ApplicationModule.setCookie(C_NAME, "true", time);
      $("#covidModal").modal('hide');
    }
  }
}
</script>

<template>
  <div id="covidModal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-sm modal-dialog-centered">
      <div class="modal-content">
        <div class="covid-modal-img">
          <button type="button" class="close" @click="setModalCookie()">&times;</button>
        </div>
        <div class="modal-body p-5 text-center">
          <h4 class="mb-0">COVID-19</h4>
          <h6 class="mb-4">'CONTACTLESS DELIVERY'</h6>
          <small> We are now delivering <b>perishable goods</b> directly to your homes. Service available in Kensington and Chelsea area.</small>
          <a href="/covid_19_services" @click.stop.prevent="linkClickHandler()" class="btn btn-primary mt-4">Find out more</a>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

  .covid-modal-img {
    padding-bottom: 56.25%;
    // background-image: url("~src/pictures/covid_banner.jpeg");
    background-size: cover;
    background-position: center center;

    & > .close {
      position: absolute;
      right: 1rem;
      top: 1rem;
    }
  }
</style>