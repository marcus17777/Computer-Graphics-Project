module.exports = ($) ->
  require('util')._extend @, $

  fs = require('fs')
  proxyMiddleware = require 'http-proxy-middleware'

  @gulp.task 'serve', ['build', 'watch'], =>

    fallback = if @config.isProduction then @config.dist.index else @config.app.indexHtml
    root     = if @config.isProduction then @config.dist.root  else @config.app.root

    @connect.server
      root: [root, './public']
      port: 3000
      livereload: true
      fallback: fallback

  @gulp.task 'watch', ['watch:coffee', 'watch:compiled']

  @gulp.task 'watch:coffee', ['coffee'], =>
    @gulp.watch @config.app.root + '/**/*.coffee', (event) ->
      if event.type == 'added'
        @gulp.start 'inject'
      else
        @gulp.start 'coffee'

  @gulp.task 'watch:compiled', =>
    @gulp.watch @config.app.root + @config.app.js, -> @connect.reload()
