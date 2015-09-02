# CHANGE LOG

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org).



## [Unreleased][unreleased]

### Added
* (JavaScript)  Default arguments for `Parser(builder)` and `Parser.parse(scanner, matcher)` 

### Changed
* (Java)        Improvements to the build process
* (JavaScript)  It's now possible to pass a string directly to `Parser.parse()`
* (Python)      [#72](https://github.com/cucumber/gherkin3/pull/72) Use new-style classes

### Fixed
* (Python)      [#74](https://github.com/cucumber/gherkin3/pull/74) File descriptors are now excplicitly closed



## [3.1.0] - 2015-08-16

### Removed
* (JavaScript) Remove `tea-error` dependency

### Added
* (.NET) [#57](https://github.com/cucumber/gherkin3/issues/57)
     and [#58](https://github.com/cucumber/gherkin3/issues/58) Release Nuget package

### Changed
* (Java) Maven `groupId` artifact changed from `info.cukes` to `io.cucumber`

### Fixed
* (All) [#62](https://github.com/cucumber/gherkin3/issues/62) Multiple calls to `parse()` cannot use the same instance of `AstBuilder` 
* (Python) [#63](https://github.com/cucumber/gherkin3/issues/63) `gherkin-languages.json` not packaged



## 3.0.0 - 2015-07-16

* First release


[unreleased]: https://github.com/cucumber/gherkin3/compare/v3.1.0...HEAD
[3.1.0]:      https://github.com/cucumber/gherkin3/compare/v3.0.0...v3.1.0
