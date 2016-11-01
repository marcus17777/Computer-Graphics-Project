module.exports = ($) ->
  require('util')._extend @, $

  @gulp.task 'inject', ['coffee'], =>
    index  = @config.app.indexHtml
    assets = @gulp.src @config.app.injectables
    root   = @config.app.root

    @gulp.src index
      .pipe @inject assets, ignorePath: root
      .pipe @gulp.dest root
