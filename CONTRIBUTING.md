Please read [CONTRIBUTING](https://github.com/cucumber/gherkin3/blob/master/CONTRIBUTING.md) first.
You should clone the [cucumber/gherkin3](https://github.com/cucumber/gherkin3) repo if you want
to contribute.

## Run tests

### Using make

Just run `make` from this directory.

### Using just Maven

Just run `mvn clean test` from this directory.

Keep in mind that this will only run unit tests. The acceptance tests are only
run when you build with `make`.

## Make a release

    # Change version in `pom.xml`
    mvn release:clean
  	mvn --batch-mode -P release-sign-artifacts release:prepare -DdevelopmentVersion=X.Y.Z+1-SNAPSHOT
  	mvn --batch-mode -P release-sign-artifacts release:perform
