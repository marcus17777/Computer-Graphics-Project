module.exports = ($) ->
  require('util')._extend @, $

  ngClassify = require 'gulp-ng-classify'

  @gulp.task 'coffee', =>
    @gulp.src @config.app.coffee
      .pipe @cache('coffee')

      .pipe @order @config.app.jsOrder

      .pipe @if @config.debug, @debug title: 'Coffee:  input:'
      .pipe @sourcemaps.init()

      .pipe ngClassify(@config.ngClassifyOptions).on 'error', @errorHandler
      .pipe @coffee().on 'error', @errorHandler

      .pipe @if @config.production, @concat 'app.js'

      .pipe @if @config.production, @rev()

      .pipe @if @config.debug, @debug title: 'Coffee: output:'
      .pipe @sourcemaps.write()

      .pipe @gulp.dest(@config.app.root)
        .on 'error', @errorHandler
