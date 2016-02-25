Please read [CONTRIBUTING](https://github.com/cucumber/gherkin/blob/master/CONTRIBUTING.md) first.
You should clone the [cucumber/gherkin](https://github.com/cucumber/gherkin) repo if you want
to contribute.

You will need `cpanm` installed on your system

## Run tests

### Using make

Just run `make` from this directory.

## Make a release

    # The version number comes from ../VERSION
    make release

## Making a trial release

If you want to make a trial release, you can temporarily edit `../VERSION` to
add `_1`, `_2`, etc to it, make a release, and upload that to CPAN. That way
you'll get your trial version smoked by CPAN Testers, but the release will be
marked as development only, and when you come to release the real version, it
won't conflict. Note that `3.2.1_1` is a trial release for `3.2.1`, not `3.2.2`,
so you might upload: `3.2.1_1`, `3.2.1_2`, and then `3.2.1` when you're happy
with it.
