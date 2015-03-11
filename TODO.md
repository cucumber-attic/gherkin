# TODO

We should close all these issues before rolling Gherkin 3 into Cucumber/SpecFlow.

- [ ] Implement compiler
  - Base it on the compiler in cucumber-ruby-core
  - Need `/testdata/good/*.feature.tescase.json` files
  - [ ] C#
  - [ ] Ruby
  - [ ] JavaScript
  - [ ] Java
- [ ] Initialise parser with language (allows for global language config)
  - [ ] C#
  - [ ] Ruby
  - [ ] JavaScript
  - [ ] Java
- [ ] Make the Parser.parse() return a generic type
  - [ ] C#
  - [x] Java
- [ ] Use JSON as the primary representation of the AST for comparison
  - [ ] C#
  - [x] Ruby
  - [x] JavaScript
  - [x] Java
- [ ] Remove the `testdata/good/*.ast` files
- [ ] Use the new `dialects.json` file
  - [ ] C#
  - [x] Ruby
  - [x] JavaScript
  - [x] Java
  - [ ] Rename to `gherkin-languages.json`
  - [ ] Remove `i18n.json`
- [ ] Rename `title` or `text` to `name` (check wiki, maybe discuss again)
  - [ ] C#
  - [ ] Ruby
  - [ ] JavaScript
  - [x] Java
- [ ] Java: Use uberjar to compile in Gson
  - [ ] Remove dependency on `gherkin-jvm-deps`
