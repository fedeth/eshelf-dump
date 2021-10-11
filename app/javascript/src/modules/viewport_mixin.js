import { debounce } from 'lodash';

const breakpoints = {
  sm: 576,
  md: 768,
  lg: 992,
  xl: 1200
}

const ViewportMixin = {
  mounted() {
    Vue.set(globalState, 'viewport', {
      xs: false,
      sm: false,
      md: false,
      lg: false,
      xl: false
    });
    this.setViewportSize();
    window.onresize = debounce(this.setViewportSize, 200)
  },
  methods: {
    setViewportSize() {
      let width = window.innerWidth;
      console.log(width);
      Vue.set(globalState.viewport, 'xs', (width < breakpoints.sm));
      Vue.set(globalState.viewport, 'sm', (width >= breakpoints.sm && width < breakpoints.md));
      Vue.set(globalState.viewport, 'md', (width >= breakpoints.md && width < breakpoints.lg));
      Vue.set(globalState.viewport, 'lg', (width >= breakpoints.lg && width < breakpoints.xl));
      Vue.set(globalState.viewport, 'xl', (width > breakpoints.xl));
    }
  }
}

export { ViewportMixin, breakpoints };