module.exports = ($) =>
  require('util')._extend @, $

  @gulp.task 'clean', =>
    removables = [
      './app/**/*.js'
    ]

    @del.sync removables
