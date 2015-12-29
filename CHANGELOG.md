# CHANGE LOG

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org).

This document is formatted according to the principles of [Keep A CHANGELOG](http://keepachangelog.com).

----

## [Unreleased][unreleased]

### Removed

### Added
* (All) Emoji translation of Gherkin
  (by [aslakhellesoy](https://github.com/aslakhellesoy))
* (Python) Implemented compiler
  ([#124](https://github.com/cucumber/gherkin3/pull/124))
  (by [Zearin](https://github.com/Zearin))
* (Objective C) New implementation
  ([#110](https://github.com/cucumber/gherkin3/pull/110))
  (by [LiohAu](https://github.com/LiohAu))

### Changed
* (I18n) Support stricter French grammar
  ([#134](https://github.com/cucumber/gherkin3/pull/134)
   by [moreau-nicolas](https://github.com/moreau-nicolas))
* (All) the AST's `DocString` `contentType` property is not defined rather than
  an empty string when the Gherkin doc doesn't specify the type after three backticks.
  (by [aslakhellesoy](https://github.com/aslakhellesoy))

### Fixed
* (Python) Fix i18n support when parsing features from strings.
  (by [brasmusson](https://github.com/brasmusson))
* (Python) Prevent token_scanner.py from (recklessly) monkey-patching io.StringIO.
  ([#121](https://github.com/cucumber/gherkin3/pull/121)
   by [zbmott](https://github.com/zbmott))
* (Travis CI) Build objective-c on Travis. Fix Travis language settings.
  ([#122](https://github.com/cucumber/gherkin3/pull/122),
   [#118](https://github.com/cucumber/gherkin3/issues/118)
   by [brasmusson](https://github.com/brasmusson))
* (All) Do not change escaped docstring separators in descriptions
  ([#115](https://github.com/cucumber/gherkin3/pull/115)
   by [brasmusson](https://github.com/brasmusson))
* (JavaScript) interpolate replaces globally
  ([#108](https://github.com/cucumber/gherkin3/pull/108))
  (by [charlierudolph](https://github.com/charlierudolph))
* (JavaScript) make parser work on Node 0.10 (as well as 4.1)
  (by [aslakhellesoy](https://github.com/aslakhellesoy))
* (Go) Fixed bug in the parser's lookahead
  (by [brasmusson](https://github.com/brasmusson))

## [3.1.2] - 2015-10-04

### Removed
* (Ruby) `Parser.parse` no longer treats `String` as a file path (only as source).

### Added
* (Ruby) `Parser.parse` now accepts a `String`, `StringIO`, `IO` or `TokenScanner`.
  ([#100](https://github.com/cucumber/gherkin3/pull/100)
  by [maxmeyer](https://github.com/maxmeyer))
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
* (Ruby) Fixed bug in the parser's lookahead
  ([#104](https://github.com/cucumber/gherkin3/issues/104)
  by [brasmusson](https://github.com/brasmusson)
  and [aslakhellesoy](https://github.com/aslakhellesoy))
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

[unreleased]: https://github.com/cucumber/gherkin3/compare/v3.1.2...HEAD
[3.1.2]:      https://github.com/cucumber/gherkin3/compare/v3.1.1...v3.1.2
[3.1.1]:      https://github.com/cucumber/gherkin3/compare/v3.1.0...v3.1.1
[3.1.0]:      https://github.com/cucumber/gherkin3/compare/v3.0.0...v3.1.0
