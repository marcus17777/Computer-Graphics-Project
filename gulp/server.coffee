module.exports = ($) ->
  require('util')._extend @, $

  fs = require('fs')
  proxyMiddleware = require 'http-proxy-middleware'

  fallback = @config.app.indexHtml
  root     = @config.app.root

  @gulp.task 'serve', ['build', 'watch'], =>
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
