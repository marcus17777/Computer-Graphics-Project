module.exports = ($) ->
  require('util')._extend @, $

  ngClassify = require 'gulp-ng-classify'

  @gulp.task 'coffee', =>
    @gulp.src @config.app.coffee
      .pipe @cache('coffee')

      .pipe @order @config.app.jsOrder

      .pipe @if @config.isDebug, @debug title: 'Coffee:  input:'
      .pipe @sourcemaps.init()

      .pipe ngClassify(@config.ngClassifyOptions).on 'error', @errorHandler
      .pipe @coffee().on 'error', @errorHandler

#      .pipe @if @config.isProduction, @uglify()
      .pipe @if @config.isProduction, @concat 'app.js'

      .pipe @if @config.isProduction, @rev()

      .pipe @if @config.isDebug, @debug title: 'Coffee: output:'
      .pipe @sourcemaps.write()

      .pipe @if @config.isProduction,
        @gulp.dest(@config.app.root)
        .on 'error', @errorHandler
