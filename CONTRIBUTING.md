Please read [CONTRIBUTING](https://github.com/cucumber/gherkin3/blob/master/CONTRIBUTING.md) first.
You should clone the [cucumber/gherkin3](https://github.com/cucumber/gherkin3) repo if you want
to contribute.

## Run tests

### Using make

Just run `make` from this directory.

### Using nosetests

Just run `nosetests` from this directory (you need to `npm test` first).

Keep in mind that this will only run unit tests. The acceptance tests are only
run when you build with `make`.

## Make a release

This is based on [How to submit a package to PyPI](http://peterdowns.com/posts/first-time-with-pypi.html)

    # Change `version` and `download_url` in `setup.py`

    # Replace X.Y.Z with the version
    git commit -m "Release X.Y.Z"
    git tag -a -m "Version X.Y.Z" vX.Y.Z
    git push
    git push --tags
    python setup.py sdist upload -r pypitest
