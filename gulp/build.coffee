module.exports = ($) ->
  require('util')._extend @, $

  @gulp.task 'build', ['clean', 'replace']
