var gulp = require('gulp');
var wrap = require('gulp-wrap-amd');
var through = require('through2');
var path = require('path');
var fs = require('fs');

function replaceAll(str, find, replace) {
  return str.split(find).join(replace);
}

gulp.task('wrap:gherkin', function () {
  gulp.src('./lib/**/*.js')
    .pipe(through.obj(function (file, enc, cb) {
      if (file.isNull()) {
        cb(null, file);
        return;
      }

      var fileName = path.basename(file.path);
      var newFileContents = replaceAll(file.contents.toString(), "require('tea-error')", "require('./tea/error')");

      if (fileName === 'token_matcher.js') {
        // token_matcher.js requires a json file. To make the file browser compatible, we need to paste the
        // contents of the json file into the js file
        return fs.readFile(path.join(__dirname, 'lib/gherkin/dialects.json'), 'utf8', function (err, data) {
          if (err) throw err;
          file.contents = new Buffer(replaceAll(newFileContents, "require('./dialects.json')", data.trim()));
          cb(null, file);
        });
      }

      file.contents = new Buffer(newFileContents);
      cb(null, file);
    }))
    .pipe(wrap({
      exports: 'module.exports'
    }))
    .pipe(gulp.dest('./dist/'))
});

gulp.task('wrap:node_modules', function () {
  gulp.src([
    './node_modules/tea-error/lib/error.js',
    './node_modules/tea-error/node_modules/tea-extend/lib/extend.js'
  ])
    .pipe(through.obj(function (file, enc, cb) {
      if (file.isNull()) {
        cb(null, file);
        return;
      }

      var newFileContents = replaceAll(file.contents.toString(), "require('tea-extend')", "require('./extend')");
      file.contents = new Buffer(newFileContents);

      cb(null, file);
    }))
    .pipe(wrap({
      exports: 'module.exports'
    }))
    .pipe(gulp.dest('./dist/gherkin/tea'))
});

gulp.task('default', ['wrap:gherkin', 'wrap:node_modules']);