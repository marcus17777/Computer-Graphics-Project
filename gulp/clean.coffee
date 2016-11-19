module.exports = ($) =>
  require('util')._extend @, $

  @gulp.task 'clean', =>
    removables = [
      'app/**/*.js',
      '!app/lib/*'
    ]

    @del.sync removables
