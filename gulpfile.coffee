@config = require('yamljs').load('./gulp/config.yml')

@isProd = @config.isProd
@isDev  = !@config.isProd

@gulp       = require 'gulp'
@del        = require 'del'
@debug      = require 'gulp-debug'
@if         = require 'gulp-if'
@coffee     = require 'gulp-coffee'
@concat     = require 'gulp-concat'
@rev        = require 'gulp-rev'
@sourcemaps = require 'gulp-sourcemaps'
@replace    = require 'gulp-replace'
@inject     = require 'gulp-inject'
@connect    = require 'gulp-connect'
@cache      = require 'gulp-cached'
@order      = require 'gulp-order'
@revReplace = require 'gulp-rev-replace'

@errorHandler = (error) ->
  console.log error.toString()
  @emit 'end'

require('./gulp/compile')(@)
require('./gulp/build')(@)
require('./gulp/server')(@)


@gulp.task 'set:production',   => @config.production   = true
@gulp.task 'set:debug',        => @config.debug        = true

@gulp.task 'default', ['build', 'serve']
