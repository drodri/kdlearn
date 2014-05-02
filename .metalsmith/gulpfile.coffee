#
# # Gulpfile
#
# The Gulpfile is responsible for compiling our Metalsmith project,
# sass, and any other build processes we may need. It also supports live
# compiling the project, and reloading the code.
#
# Run with `cult`, and see README.md for more usage docs.
#
metal   = require './metal'
path    = require 'path'
connect = require 'connect'
gulp    = require 'gulp'
sass    = require 'gulp-sass'
util    = require 'gulp-util'



paths =
  code: [
    '../.metalsmith/*'
    '../.metalsmith/templates/**'
  ]
  documents: [
    '!../.metalsmith'
    '!node_modules/**'
    '../**'
  ]
  sass: './sass/**/*.scss'


# ## metalsmith
#
# Compile our metalsmith markdown and templates.
gulp.task 'metalsmith', -> metal()


# ## sass
#
# Compile our sass to css in the build dir.
gulp.task 'sass', ->
  gulp.src paths.sass
    .pipe sass()
    .pipe gulp.dest 'build/css'


# ## watch:code
#
# Watch the metalsmith code and reload it when changes are detected.
# Note that this will not reload changes to this Gulpfile.
gulp.task 'watch:code', -> gulp.watch paths.code, ->
  util.log 'Code changed, reloading and compiling.'
  delete require.cache[path.join __dirname, 'metal.coffee']
  metal = require './metal'
  metal()


# ## watch:md
#
# Run a web server exposing the files in the build directory, and recompile
# the markdown on change.
gulp.task 'watch:md', ['build'], ->
  # Start a connect server to display our files
  connect()
    .use connect.static path.join __dirname, 'build'
    .listen 8000
  util.log 'Started web server on port 8000'
  gulp.watch paths.documents, ['build']


gulp.task 'watch', ['watch:md']
gulp.task 'watch:all', ['watch:md', 'watch:code']
gulp.task 'build', ['metalsmith', 'sass']
gulp.task 'default', ['build']