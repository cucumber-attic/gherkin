# Gherkin 3 - Ruby Parser

## Using make

Just run `make` from this directory.

## Using just Maven

Just run `mvn clean test` from this directory.

Keep in mind that this will only run unit tests. The acceptance tests are only
run when you build with `make`.

## Code Coverage

Generate coverage data:

    make

Now, generate the coverage report

    mvn jacoco:report
    open target/site/jacoco/index.html
