<script>

export default {
  props: {
    'vueContent': {
      type: Object,
    }
  },
  mounted: function() {
    Vue.nextTick(() => {
      for(let i = 0; i < this.content.faqs.length; i++) {
        $(`#collapse-${i}`).on('show.bs.collapse', function () {
          let arrow = document.getElementById(`arrow-${i}`);
          arrow.classList.add("rotate180");
        });
        $(`#collapse-${i}`).on('hide.bs.collapse', function () {
          let arrow = document.getElementById(`arrow-${i}`);
          arrow.classList.remove("rotate180");
        });
      }
    });
  },
  data: function () {
    return {
      content: this.vueContent,
    }
  },
}
</script>

<template>
  <div class="bg-light-grey">
    <div id="faqs" v-if="content.faqs" class="container py-5">
      <div class="row pb-5 pt-3">
        <div class="d-none d-md-block col-auto col-sidebar">
          <static-page-sidebar></static-page-sidebar>
        </div>
        <div class="col p-5 bg-white">
          <h2 class="pb-5">FAQs</h2>
          <div class="accordion" id="faqId">
            <div v-for="(faq, index) in content.faqs" :key="`faq-${index}`" class="card">
              <div class="card-header" :id="`heading-${index}`">
                <a class="btn btn-link text-std-grey w-100 text-left position-relative px-0" role="button" data-toggle="collapse" :data-target="`#collapse-${index}`" aria-expanded="true" :aria-controls="`collapse-${index}`">
                  <div class="arrow position-absolute d-flex align-items-center h-100"><i :id="`arrow-${index}`" class="fas fa-chevron-down"></i></div>
                  <div class="faq">{{faq[0]}}</div>
                </a>
              </div>
              <div :id="`collapse-${index}`" class="collapse" :aria-labelledby="`heading-${index}`">
                <div class="card-body">
                  <div v-html="JSON.parse(faq[1])"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
 
</template>

<style lang="scss" scoped>

  .card {
    border-radius: 0;
    border-left: none;
    border-right: none;
    border-color: $std-grey;

    .card-header {
      background-color: $white;
      cursor: pointer;
      
      a {
        font-size: 1.25rem;
        &:hover {
          color: $blue;
        }
      }

      .arrow {
        right: 0;
        top: 0;
        i {
          font-size: 1.5rem;
          transition: all 0.5s;
          &.rotate180 {
            transform: rotate(180deg);
          }
        }
      }
    }

    .faq {
      padding-right: 2.25rem;
    }
  }
  
</style>


 

