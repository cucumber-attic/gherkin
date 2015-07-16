Please read [CONTRIBUTING](https://github.com/cucumber/gherkin3/blob/master/CONTRIBUTING.md) first.
You should clone the [cucumber/gherkin3](https://github.com/cucumber/gherkin3) repo if you want
to contribute.

## Run tests

### Using make

Just run `make` from this directory.

### Using npm

Just run `npm test` from this directory (you need to `npm test` first).

Keep in mind that this will only run unit tests. The acceptance tests are only
run when you build with `make`.

## Browser Build

    make dist/gherkin.js

## Make a release

    npm outdated --depth 0 # See if you can upgrade anything
    npm version NEW_VERSION -m
    npm publish
