# CHANGE LOG

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org).

This document is formatted according to the principles of [Keep A CHANGELOG](http://keepachangelog.com).

----

## [Unreleased][unreleased]

### Added
* (All)         It's now possible to pass a default language to the TokenMatcher.
                Previously it only worked in Javascript.
  ([#78](https://github.com/cucumber/gherkin3/issues/78)
   by [brasmusson](https://github.com/brasmusson))
* (JavaScript) Added browserified `dist/gherkin.js` and `dist/gherkin.min.js` by [aslakhellesoy](https://github.com/aslakhellesoy)

### Changed
* (Python) Use `@properties` in Dialect class
  ([#86](https://github.com/cucumber/gherkin3/pull/86)
   by [Zearin](https://github.com/Zearin))

### Fixed
* (Python) Fix file parsing on Windows.
  ([#93](https://github.com/cucumber/gherkin3/issues/93)
   by [brasmusson](https://github.com/brasmusson))

## [3.1.1] - 2015-09-03

### Added
* (All)         Added Bosnian
  ([#48](https://github.com/cucumber/gherkin3/pull/48)
   by [10-io](https://github.com/10-io))
* (All)         Added support for `\n`, '\|' and '\\' in table cells
  ([#40](https://github.com/cucumber/gherkin3/issues/40),
   [#71](https://github.com/cucumber/gherkin3/pull/71)
   by [koterpillar](https://github.com/koterpillar))
* (JavaScript)  Default arguments for `Parser(builder)` and `Parser.parse(scanner, matcher)`
  (by [aslakhellesoy](https://github.com/aslakhellesoy))
* (JavaScript)  It's now possible to pass a string directly to `Parser.parse()`
* (Python)      It's now possible to pass a string directly to `Parser.parse()`
  (by [aslakhellesoy](https://github.com/aslakhellesoy))


### Changed
* (Java)        Improvements to the build process
* (Python)      Use new-style classes
  ([#72](https://github.com/cucumber/gherkin3/pull/72))

### Fixed
* (Python) File descriptors are now excplicitly closed
  ([#74](https://github.com/cucumber/gherkin3/pull/74))

## [3.1.0] - 2015-08-16

### Removed
* (JavaScript) Remove `tea-error` dependency

### Added
* (.NET) Release Nuget package
  ([#57](https://github.com/cucumber/gherkin3/issues/57),
   [#58](https://github.com/cucumber/gherkin3/issues/58))

### Changed
* (Java) Maven `groupId` artifact changed from `info.cukes` to `io.cucumber`

### Fixed
* (All) Multiple calls to `parse()` cannot use the same instance of `AstBuilder`
  ([#62](https://github.com/cucumber/gherkin3/issues/62))
* (Python) `gherkin-languages.json` not packaged
  ([#63](https://github.com/cucumber/gherkin3/issues/63))



## 3.0.0 - 2015-07-16

* First release


[unreleased]: https://github.com/cucumber/gherkin3/compare/v3.1.1...HEAD
[3.1.1]:      https://github.com/cucumber/gherkin3/compare/v3.1.0...v3.1.1
[3.1.0]:      https://github.com/cucumber/gherkin3/compare/v3.0.0...v3.1.0
