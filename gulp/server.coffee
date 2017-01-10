module.exports = ($) ->
  require('util')._extend @, $

  @gulp.task 'serve', ['clean', 'compile'], =>

    fallback = @config.app.indexHtml
    root     = @config.app.root

    @connect.server
      root: [root, './public']
      port: 3000
      livereload: true
      fallback: fallback

  @gulp.task 'compile', ['compile:coffee'], =>
    @gulp.watch @config.app.root + '/**/*.coffee', (event) ->
      @gulp.start 'compile:coffee'
