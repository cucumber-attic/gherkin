# Contributing to Gherkin 3

Gherkin3 is implemented in several different languages, and each language implementation
lives in a separate git repository.

The code in each of those git repositories can be built and used independently.
This is useful for people who only want to *use* Gherkin without *contributing*
to Gherkin.

Gherkin *contributors* should clone *this* repository. This will automatically get
you a copy of the files in the various `gherkin-*` repositories.

When you're done, just create a pull request against *this* repository.

## Gherkin team

Before you do anything, make sure you set up remotes for the subtrees:

    make add-remotes

When you have made a change (or merged a PR from a contributor) you can sync them
to the individual `gherkin-*` repos:

    make push-subtrees

Or if someone has made changes to a `gherkin-*` repo independently:

    make pull-subtrees

This should only be done on rare occasions - it's always better to make changes against
this *master* repo.

## Building

Prerequisites:

* .NET or Mono (needed to run `berp` to generate parsers)
* JDK
  * Maven
* Node.js or IO.js
* Ruby
* `make`
* `jq`
* `diff`
* `git`

With all this installed, just run `make` from the root directory.

## Contributing changes

* Create a feature branch for your change.
* Don't lump unrelated changes together.
* If you change code, please make sure all implementations are changed accordingly.
  * If you don't to do this, we might reject your patch because the burden to keep parsers in sync is now on us.

## Building individual parsers

It's possible to build the parser for a single language too. Please refer to
`CONTRIBUTING.md` files in each language directory for details.

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
or find us on [Gitter](https://gitter.im/cucumber/gherkin3).

## Make a release

Releases are made from the various subtrees. Before you release, update the subtrees:

    make push-subtrees

Next, clone each individual subtree repo (or `git pull` if you've already done so)
in your working copy of each subtree, then follow the release guidelines
for each component in the respective `CONTRIBUTING.md` file.

When all components are released, update the master repo:

    make pull-subtrees

Then finally create a tag there:

    git tag v3.0.0

## Benchmarking

Just run `./perf` to get a rough idea of performance. This script will print
how many milliseconds it takes to parse all the files under `testdata/good`

## Verify all of Cucumber's i18n examples

If you have [cucumber-ruby](https://github.com/cucumber/cucumber-ruby) cloned
next to the gherkin3 directory, try processing all of the files.

With just the scanner:

    [LANGUAGE]/bin/gherkin-generate-tokens `find ../cucumber-ruby/examples -name "*.feature"`

With the parser:

    [LANGUAGE]/bin/gherkin-generate-ast `find ../cucumber-ruby/examples -name "*.feature"`

## Adding new good testdata

1) Add a `.feature` file to `testdata/good`

2) Generate the tokens:

    # For example
    [LANGUAGE]/bin/gherkin-generate-tokens \
    testdata/good/newfile.feature > \
    testdata/good/newfile.feature.tokens

3) Inspect the generated `.feature.tokens` file manually to see if it's good.

4) Generate the ast:

    [LANGUAGE]/bin/gherkin-generate-ast \
    testdata/good/newfile.feature | \
    jq --sort-keys "." > \
    testdata/good/newfile.feature.ast.json

5) Inspect the generated `.feature.ast.json` file manually to see if it's good.

6) Run `make` from the root directory to verify that all parsers parse it ok.
