# CHANGE LOG

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org).

This document is formatted according to the principles of [Keep A CHANGELOG](http://keepachangelog.com).

----

## [Unreleased] - TBD

### Removed

### Added
* (JavaScript) Expose dialects
  ([#177](https://github.com/cucumber/gherkin/pull/177)
   by [charlierudolph])
* (Perl) new implementation!
  ([#161](https://github.com/cucumber/gherkin/pull/161)
   by [pjlsergeant])
* (Objective-C) Added Objective-C example to the README
  ([#152](https://github.com/cucumber/gherkin/pull/152)
   by [Ahmed-Ali])
* (I18n) ru: Add "Функциональность" as translation of Feature
  ([#165](https://github.com/cucumber/gherkin/pull/165)
   by [nixel2007])

### Changed
* (All) Rename Feature.scenarioDefinitions to Feature.children
  (by [aslakhellesoy])
* (All) Background as part of Feature.children
  ([#178](https://github.com/cucumber/gherkin/pull/174)
   by [aslakhellesoy])
* (All) Remove scenario keyword from pickles
  ([#176](https://github.com/cucumber/gherkin/pull/176)
   by [charlierudolph])
* (All) Don't make pickles out of step-less scenarios
  ([#174](https://github.com/cucumber/gherkin/pull/175)
   by [enkessler])
* (Ruby) More consistent AST node types
  ([#158](https://github.com/cucumber/gherkin/pull/158)
   by [enkessler])
* (All) Allow incomplete scenario outlines
  ([#160](https://github.com/cucumber/gherkin/pull/160),
   [#170](https://github.com/cucumber/gherkin/pull/170)
   by [brasmusson])

### Fixed
* (Ruby) Use require instead of require_relative
  ([#173](https://github.com/cucumber/gherkin/pull/173)
   by [maximeg])
* (JavaScript) Fixed undefined reference to stopOnFirstError on ES6
  (by [aslakhellesoy])
* (Python) Add the `gherkin.pickles` package to the Python installation
  ([#157](https://github.com/cucumber/gherkin/pull/157),
   [#156](https://github.com/cucumber/gherkin/issues/156)
   by [Zearin])
* (Ruby, Java) Make parser work even when system encoding ($LANG) is not UTF-8.
  ([#151](https://github.com/cucumber/gherkin/issues/151)
   by [aslakhellesoy])

## [3.2.0] - 2016-01-12

### Removed

### Added
* (I18n) Mongolian translation of Gherkin
  ([#140](https://github.com/cucumber/gherkin/pull/140)
   by [jargalan])
* (I18n) Emoji translation of Gherkin
  (by [aslakhellesoy])
* (Python) Implemented compiler
  ([#124](https://github.com/cucumber/gherkin/pull/124)
   by [Zearin])
* (Objective C) New implementation
  ([#110](https://github.com/cucumber/gherkin/pull/110)
   by [LiohAu])

### Changed
* (All) changed package/module/repo name from `gherkin3` to `gherkin`. (Python package is called `gherkin-official`)
* (I18n) Improved Malay translation of Gherkin
  ([#132](https://github.com/cucumber/gherkin/pull/132)
   by [gabanz])
* (I18n) Improved Irish translation of Gherkin
  ([#135](https://github.com/cucumber/gherkin/pull/135)
   by [merrua])
* (All) Escape only '|', 'n' and '\' in table cells
  ([#114](https://github.com/cucumber/gherkin/pull/114)
   by [brasmusson])
* (I18n) Support stricter French grammar
  ([#134](https://github.com/cucumber/gherkin/pull/134)
   by [moreau-nicolas])
* (All) the AST's `DocString` `contentType` property is not defined rather than
  an empty string when the Gherkin doc doesn't specify the type after three backticks.
  (by [aslakhellesoy])

### Fixed
* (Python) Fix i18n support when parsing features from strings.
  (by [brasmusson])
* (All) Do not change escaped docstring separators in descriptions
  ([#115](https://github.com/cucumber/gherkin/pull/115)
   by [brasmusson])
* (Travis CI) Build Objective-C on Travis. Fix Travis language settings.
  ([#122](https://github.com/cucumber/gherkin/pull/122),
   [#118](https://github.com/cucumber/gherkin/issues/118),
   by [brasmusson])
* (Python) Don't monkey-patch `io.StringIO` in `token_scanner.py`
  ([#121](https://github.com/cucumber/gherkin/pull/121)
   by [zbmott])
* (JavaScript) Interpolate replaces globally
  ([#108](https://github.com/cucumber/gherkin/pull/108)
   by [charlierudolph])
* (JavaScript)  Make parser work on Node 0.10 and 4.1
  (by [aslakhellesoy])
* (Go) Fix lookahead bug in the parser
  (by [brasmusson])

## [3.1.2] - 2015-10-04

### Added
* (All) `TokenMatcher` now accepts a default language
  (previously, only JavaScript had this behavior)
  ([#78](https://github.com/cucumber/gherkin/issues/78)
   by [brasmusson])
* (Ruby) `Parser.parse` now accepts a `String`, `StringIO`, `IO` or `TokenScanner`
  ([#100](https://github.com/cucumber/gherkin/pull/100)
   by [maxmeyer])
* (JavaScript) Add browserified `dist/gherkin.js` and `dist/gherkin.min.js`
  (by [aslakhellesoy])

### Changed
* (Python) Use `@properties` in `Dialect` class
  ([#86](https://github.com/cucumber/gherkin/pull/86)
   by [Zearin])
* (Ruby) `Parser.parse` now treats `String` as source (not a file path)

### Fixed
* (Ruby) Fix lookahead bug in the parser
  ([#104](https://github.com/cucumber/gherkin/issues/104)
   by [brasmusson]
   and [aslakhellesoy])
* (Python) Fix file parsing on Windows
  ([#93](https://github.com/cucumber/gherkin/issues/93)
   by [brasmusson])

## [3.1.1] - 2015-09-03

### Added
* (All) Add Bosnian
  ([#48](https://github.com/cucumber/gherkin/pull/48)
   by [paigehf])
* (All) Add support for `\n`, '\|', and '\\' in table cells
  ([#40](https://github.com/cucumber/gherkin/issues/40),
   [#71](https://github.com/cucumber/gherkin/pull/71),
   by [koterpillar])
* (JavaScript)  Default arguments for `Parser(builder)` and `Parser.parse(scanner, matcher)`
  (by [aslakhellesoy])
* (JavaScript) It's now possible to pass a string directly to `Parser.parse()`
* (Python) It's now possible to pass a string directly to `Parser.parse()`
  (by [aslakhellesoy])


### Changed
* (Java) Improved build process
* (Python) Use new-style classes
  ([#72](https://github.com/cucumber/gherkin/pull/72)
   by [Zearin])

### Fixed
* (Python) File descriptors are now explicitly closed
  ([#74](https://github.com/cucumber/gherkin/pull/74)
   by [Zearin])

## [3.1.0] - 2015-08-16

### Removed
* (JavaScript) Remove `tea-error` dependency

### Added
* (.NET) Release Nuget package
  ([#57](https://github.com/cucumber/gherkin/issues/57),
   [#58](https://github.com/cucumber/gherkin/issues/58))

### Changed
* (Java) Change Maven `groupId` artifact from `info.cukes` to `io.cucumber`

### Fixed
* (All) Multiple calls to `parse()` cannot use the same instance of `AstBuilder`
  ([#62](https://github.com/cucumber/gherkin/issues/62))
* (Python) `gherkin-languages.json` not packaged
  ([#63](https://github.com/cucumber/gherkin/issues/63))


## 3.0.0 - 2015-07-16

* First release

<!-- Releases -->
[Unreleased]: https://github.com/cucumber/gherkin/compare/v3.2.0...HEAD
[3.2.0]:      https://github.com/cucumber/gherkin/compare/v3.1.2...v3.2.0
[3.1.2]:      https://github.com/cucumber/gherkin/compare/v3.1.1...v3.1.2
[3.1.1]:      https://github.com/cucumber/gherkin/compare/v3.1.0...v3.1.1
[3.1.0]:      https://github.com/cucumber/gherkin/compare/v3.0.0...v3.1.0

<!-- Contributors -->
[Ahmed-Ali]:        https://github.com/Ahmed-Ali
[aslakhellesoy]:    https://github.com/aslakhellesoy
[brasmusson]:       https://github.com/brasmusson
[charlierudolph]:   https://github.com/charlierudolph
[enkessler]:        https://github.com/enkessler
[gabanz]:           https://github.com/gabanz
[jargalan]:         https://github.com/jargalan
[koterpillar]:      https://github.com/koterpillar
[LiohAu]:           https://github.com/LiohAu
[maximeg]:          https://github.com/maximeg
[maxmeyer]:         https://github.com/maxmeyer
[merrua]:           https://github.com/merrua
[moreau-nicolas]:   https://github.com/moreau-nicolas
[nixel2007]:        https://github.com/nixel2007
[paigehf]:          https://github.com/paigehf
[pjlsergeant]:      https://github.com/pjlsergeant
[zbmott]:           https://github.com/zbmott
[Zearin]:           https://github.com/Zearin
