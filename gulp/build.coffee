module.exports = ($) ->
  require('util')._extend @, $

  @gulp.task 'build', ['clean', 'inject']

  @gulp.task 'clean', =>
    removables = [
      'app/**/*.js',
      '!app/lib/*'
    ]
    @del.sync removables

  @gulp.task 'inject', ['coffee'], =>
    index  = @config.app.indexHtml
    assets = @gulp.src @config.app.injectables
    root   = @config.app.root

    @gulp.src index
      .pipe @inject assets, ignorePath: root, addRootSlash: false
      .pipe @gulp.dest root
