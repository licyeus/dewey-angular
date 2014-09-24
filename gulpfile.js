var gulp = require('gulp'),
    livereload = require('gulp-livereload'),
    less = require('gulp-less'),
    concat = require('gulp-concat'),
    jshint = require('gulp-jshint'),
    connect = require('gulp-connect'),
    jade = require('gulp-jade'),
    gutil = require('gulp-util'),
    coffee = require('gulp-coffee');

var dest = 'dist/',
    source = 'app/';

gulp.task('connectDev', function () {
  connect.server({
    root: dest,
    port: 8000,
    livereload: true
  });
});

gulp.task('less', function() {
  return gulp.src(source + 'css/**/*.less')
    .pipe(less())
    .pipe(gulp.dest(dest + 'css/'))
    .pipe(connect.reload());
});

gulp.task('templates', function() {
  var YOUR_LOCALS = {};
  gulp.src(source + 'templates/*.jade')
    .pipe(jade({ locals: YOUR_LOCALS }))
    .pipe(gulp.dest(dest))
    .pipe(connect.reload());
});

gulp.task('coffee', function() {
  gulp.src(source + 'src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest(dest + 'src/'))
    .pipe(connect.reload());
});

var filesToMove = [
  './app/img/**/*.*',
  './app/manifest.json'
];

gulp.task('move', function() {
  gulp.src(filesToMove, { base: './app/' })
    .pipe(gulp.dest('dist'));
});

gulp.task('build', ['templates', 'less', 'coffee', 'move']);

gulp.task('watch', function() {
  gulp.watch([source + 'templates/**/*.jade'], ['templates']);
  gulp.watch([source + 'css/**/*.less'], ['less']);
  gulp.watch([source + 'src/**/*.coffee'], ['coffee']);
});

gulp.task('default', ['build', 'connectDev', 'watch']);
