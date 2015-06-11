require 'gherkin3/parser'
require 'gherkin3/token_scanner'
require 'gherkin3/token_matcher'
require 'gherkin3/ast_builder'
require 'rspec'

module Gherkin3
  describe Parser do
    it "parses a simple feature" do
      parser = Parser.new
      scanner = TokenScanner.new("Feature: test")
      builder = AstBuilder.new
      ast = parser.parse(scanner, builder, TokenMatcher.new)
      expect(ast).to eq({
        type: :Feature,
        tags: [],
        location: {line: 1, column: 1},
        language: "en",
        keyword: "Feature",
        name: "test",
        scenarioDefinitions: [],
        comments: []
      })
    end
  end
end
