# Gherkin 3 - JavaScript Parser

## Run tests

### Using make

Just run `make` from this directory.

### Using npm

Just run `npm test` from this directory (you need to `npm test` first).

Keep in mind that this will only run unit tests. The acceptance tests are only
run when you build with `make`.

## Build

### For the browser

    make dist/gherkin.js

### AMD

Not sure what's needed. Maybe it's sufficient to just add a header:

```javascript
define(function(require,exports,module){
```

And a footer:

```javascript
return module.exports;
});
```

Around the generated `dist/gherkin.js` file (and output this to `dist/gherkin.amd.js`).

Someone familiar with AMD please confirm!
