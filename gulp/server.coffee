module.exports = ($) ->
  require('util')._extend @, $

  @gulp.task 'serve', ['clean', 'watch:coffee', 'watch:compiled'], =>

    fallback = @config.app.indexHtml
    root     = @config.app.root

    @connect.server
      root: [root, './public']
      port: 3000
      livereload: true
      fallback: fallback

  @gulp.task 'watch:coffee', ['coffee'], =>
    @gulp.watch @config.app.root + '/**/*.coffee', (event) ->
      @gulp.start 'coffee'

  @gulp.task 'watch:compiled', =>
    @gulp.watch @config.app.root + @config.app.js, -> @connect.reload()
