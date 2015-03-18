# Contributing to Gherkin 3

Prerequisites:

* .NET or Mono (needed to run `berp` to generate parsers)
* JDK
  * Maven
* Node.js or IO.js
* Ruby
* `make`
* `jq`
* `diff`

With all this installed, just run `make` from the root directory.

## Contributing changes

* Create a feature branch for your change.
* Don't lump unrelated changes together.
* If you change code, please make sure all implementations are changed accordingly.
  * If you don't to do this, we might reject your patch because the burden to keep parsers in sync is now on us.

## Building individual parsers

It's possible to build the parser for a single language too. Please refer to
`README.md` files in each language directory for details.

## Running tests

Each sub project has its own unit tests that are run during the build of that project.

In addition to these tests, `make` will run acceptance tests that verify the output of:

* the scanner
* the parser
* the compiler (WIP)

This is done by consuming the `*.feature` files under `/testdata` and comparing the actual
output with expected output (`*.feature.tokens` and `*.feature.ast.json` files) using `diff`.

`make` will remove the generated file unless it is identical to the expected file so that
it will try to regenerate it the next time you run `make`.

When all files are identical and successfully compared, `make` will create the `.compared`
file, indicating that the acceptance tests passed.

## Implementing a parser for a new language

First off, fork the repository and create a branch for the new language.

We recommend starting with a new `Makefile`, tweak it, run it and gradually
add the missing pieces. Please follow the implementation as closely as possible
to the other implementations. This will make it easier to maintain in the future.

Create a new directory for the new language and copy the `Makefile` from one
of the existing implementations. Now, modify the parts of the `Makefile` that
generates the `Parser.x` file, referring to the `gherkin-x.razor` file you're
about to create.

When you run `make` it should complain that `gherkin-x.razor` does not exist.

Now, copy a `.razor` file form one of the other implementations.

Your `.built` target should compile your code (if necessary) and run unit tests.
You won't need a lot of unit tests (the cross-platform acceptance tests are pretty
good), but writing a few during development might help you progress.

You'll spend quite a bit of time fiddling with the `.razor` template to make it
generate code that is syntactically correct.

When you get to that stage, `make` will run the acceptance tests, which iterate
over all the `.feature` files under `/testdata`, passes them through your
`bin/gherkin-generate-tokens` and `bin/gherkin-generate-ast` command-line programs,
and compares the output using `diff`.

You'll start out with lots of errors, and now you just code until all acceptance tests
pass!

Then send us a pull-request :-)

And if you're stuck - please shoot an email to the *cukes-devs* Google Group
or find us on the *#cucumber* IRC channel on freenode.net.

## Make a release

TODO

## Benchmarking

A simple way to benchmark the scanner:

    ruby/bin/gherkin-generate-tokens       `find ../cucumber/examples -name "*.feature"`
    javascript/bin/gherkin-generate-tokens `find ../cucumber/examples -name "*.feature"`

or parser:

    ruby/bin/gherkin-generate-ast       `find ../cucumber/examples -name "*.feature"`
    javascript/bin/gherkin-generate-ast `find ../cucumber/examples -name "*.feature"`

## Adding new good testdata

1) Add a `.feature` file to `testdata/good`
2) Generate the tokens:

    # For example
    ruby ruby/bin/gherkin-generate-tokens \
    testdata/good/newfile.feature > \
    testdata/good/newfile.feature.tokens

3) Inspect the generated `.feature.tokens` file manually to see if it's good.
4) Generate the tokens:

    # For example
    ruby ruby/bin/gherkin-generate-tokens \
    testdata/good/newfile.feature | \
    jq --sort-keys "." > \
    testdata/good/newfile.feature.tokens

5) Inspect the generated `.feature.ast.json` file manually to see if it's good.
6) Run `make` from the root directory to verify that all parsers parse it ok.
