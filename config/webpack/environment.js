const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')
const path = require("path")
const webpack = require('webpack')
// const erb = require(path.resolve("config/webpack/loaders/erb.js"))

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default']
  })
)

const resolver = {
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  }
}

environment.config.merge(resolver)

const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

const sass = require('./loaders/sass')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.loaders.append("erb", erb)
environment.loaders.append("sass", sass)

module.exports = environment
