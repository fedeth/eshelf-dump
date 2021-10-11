<script>

export default {

  mounted: function() {
  },
  data: function () {
    return {
      foo: { bar: 1},
    }
  },
  methods:{
    fooBarMethod: function() { },
  },
  computed: {
    fooBarComputed: function(){
      return "foobar";
    }
  }
}
</script>

<template>
  <div class="spinner-loader flex-column">
    <div class="lds-ring">
      <div></div>
      <div></div>
      <div></div>
      <div></div>
    </div>
    <div class="spinner-text pt-2">Please wait...</div>
  </div>
    
</template>

<style lang="scss">
  .spinner-loader {
    width: 100%;
    height: 100%;
    min-height: 400px;
    position: absolute;
    background-color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 998;
    opacity: 0.75;
  }
  .spinner-text{
    font-size: 1.5rem;
  }

  .lds-ring {
    display: inline-block;
    position: relative;
    z-index: 999;
    width: 100px;
    height: 100px;
  }
  .lds-ring div {
    z-index: 999;
    box-sizing: border-box;
    display: block;
    position: absolute;
    width: 84px;
    height: 84px;
    margin: 8px;
    border: 8px solid $std_blue;
    border-radius: 50%;
    animation: lds-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
    border-color: $std_blue transparent transparent transparent;
  }
  .lds-ring div:nth-child(1) {
    animation-delay: -0.45s;
  }
  .lds-ring div:nth-child(2) {
    animation-delay: -0.3s;
  }
  .lds-ring div:nth-child(3) {
    animation-delay: -0.15s;
  }
  @keyframes lds-ring {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }

</style>
