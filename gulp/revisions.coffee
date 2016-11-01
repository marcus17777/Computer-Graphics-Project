module.exports = ($) ->
  require('util')._extend @, $

  @gulp.task 'replace', ['inject'], =>
    if @config.isProduction
      manifest = @gulp.src @config.dist.manifest

      files = [ 'dist/lib-*.css', 'dist/app-*.{js,css}', 'dist/**/*.html' ]
      @gulp.src files
      .pipe @revReplace manifest: manifest
      .pipe @gulp.dest @config.dist.root
