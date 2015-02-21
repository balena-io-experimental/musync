path = require('path')
gulp = require('gulp')
mocha = require('gulp-mocha')
coffeelint = require('gulp-coffeelint')

OPTIONS =
	config:
		coffeelint: path.join(__dirname, 'coffeelint.json')
	files:
		coffee: [
			'lib/**/*.coffee',
			'tests/**/*.spec.coffee',
			'gulpfile.coffee'
		]
		app: 'lib/**/*.coffee'
		tests: 'tests/**/*.spec.coffee'

gulp.task 'test', ->
	gulp.src(OPTIONS.files.tests, read: false)
		.pipe(mocha({
			reporter: 'landing'
		}))

gulp.task 'lint', ->
	gulp.src(OPTIONS.files.coffee)
		.pipe(coffeelint({
			optFile: OPTIONS.config.coffeelint
		}))
		.pipe(coffeelint.reporter())

gulp.task 'build', [
	'lint'
	'test'
]

gulp.task 'watch', [ 'build' ], ->
	gulp.watch([ OPTIONS.files.coffee ], [ 'build' ])
