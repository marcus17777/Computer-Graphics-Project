module.exports = ($) ->
  require('util')._extend @, $

  @gulp.task 'inject', ['coffee'], =>
    if @config.isProduction
      index  = @config.dist.index
      assets = @gulp.src @config.dist.injectables
      root   = @config.dist.root
    else
      index  = @config.app.indexHtml
      assets = @gulp.src @config.app.injectables
      root   = @config.app.root

    @gulp.src index
      .pipe @inject assets, ignorePath: root
      .pipe @gulp.dest root
