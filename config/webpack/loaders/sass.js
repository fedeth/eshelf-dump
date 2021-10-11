module.exports = {
  test: /\.scss$/,
    use: [
    // Creates `style` nodes from JS strings
    'vue-style-loader',
    // Translates CSS into CommonJS
    'css-loader',
    // Compiles Sass to CSS
    {
      loader: 'sass-loader',
      options: {
        // you can also read from a file, e.g. `variables.scss`
        // use `data` here if sass-loader version < 8
        data: `@import "~bootstrap/scss/functions";
               @import "~bootstrap/scss/variables";
               @import "~bootstrap/scss/mixins";
               @import "~src/stylesheets/variables.scss";`

      }
    }
  ]
};