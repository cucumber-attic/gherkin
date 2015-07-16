Please read [CONTRIBUTING](https://github.com/cucumber/gherkin3/blob/master/CONTRIBUTING.md) first.
You should clone the [cucumber/gherkin3](https://github.com/cucumber/gherkin3) repo if you want
to contribute.

## Using make

Just run `make` from this directory.

## Using just Maven

Just run `mvn clean test` from this directory.

Keep in mind that this will only run unit tests. The acceptance tests are only
run when you build with `make`.

## Make a release

    # TODO: Use the maven release plugin

    # Change version in `pom.xml`
    mvn -Psign clean source:jar javadoc:jar deploy
