module.exports = ($) ->
  require('util')._extend @, $

  @gulp.task 'compile:coffee', =>
    @gulp.src @config.app.coffee
      .pipe @cache('coffee')

      .pipe @sourcemaps.init()
      .pipe @coffee().on 'error', @errorHandler
      .pipe @sourcemaps.write()

      .pipe @gulp.dest(@config.app.root)
        .on 'error', @errorHandler


  @gulp.task 'clean', =>
    to_remove = [
      'app/**/*.js',
      '!app/lib/**'
    ]
    @del.sync to_remove
