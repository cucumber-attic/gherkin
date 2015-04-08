var assert = require('assert');
var Gherkin = require('..');

describe('Parser', function () {
  it("parses a simple feature", function () {
    var parser = new Gherkin.Parser();
    var scanner = new Gherkin.TokenScanner("Feature: hello");
    var builder = new Gherkin.AstBuilder();
    var ast = parser.parse(scanner, builder, new Gherkin.TokenMatcher());
    assert.deepEqual(ast, {
      type: 'Feature',
      tags: [],
      location: { line: 1, column: 1 },
      language: 'en',
      keyword: 'Feature',
      name: 'hello',
      description: undefined,
      background: undefined,
      scenarioDefinitions: [],
      comments: []
    });
  });
});
