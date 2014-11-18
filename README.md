# Gherkin 3

[![Build Status](https://travis-ci.org/cucumber/gherkin3.png)](https://travis-ci.org/cucumber/gherkin3)

Gherkin 3 is a cross-platform parser for the Gherkin language,
used by Cucumber to parse `.feature` files.

## Building Gherkin 3

Gherkin 3 uses [berp](https://github.com/gasparnagy/berp) to generate parsers
based on the Gherkin grammar defined in `gherkin.berp`.

You need .Net or Mono installed to generate the grammar.

### C# ###

#### Windows

Open `Gherkin.CSharp.sln` from the `csharp` directory in Visual Studio 2013 and build

or

Run `msbuild` from the `csharp` directory.

#### OS X/Linux

Run `make` from the `csharp` directory.

### Ruby

Run `rake` from the `ruby` directory.

### Java

TODO

### JavaScript

TODO

## Running tests

Each sub project has its own unit tests that are run during the build of that project.

In addition to these tests there are acceptance tests that verify that all parsers
tokenise consistently and generate consitent ASTs. This is done by comparing string output
from the tokeniser and the string representation of ASTs.

## Make a release

TODO

# TODO

* Rename `title` to `name` in all impls
* In .NET, rename step `text` to `name`
* Refactor java code to use java naming conventions
* Make sure the .ast files parse and render back to themselves (they currently don't for docstrings)
* Try to implement the lexer using state functions as described in [Rob Pike’s talk on writing the text/template lexer](https://www.youtube.com/watch?v=HxaD_trXwRE)
