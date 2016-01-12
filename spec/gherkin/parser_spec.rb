require 'gherkin/parser'
require 'gherkin/token_scanner'
require 'gherkin/token_matcher'
require 'gherkin/ast_builder'
require 'gherkin/errors'
require 'rspec'

module Gherkin
  describe Parser do
    it "parses a simple feature" do
      parser = Parser.new
      scanner = TokenScanner.new("Feature: test")
      ast = parser.parse(scanner)
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

    it "parses string feature" do
      parser = Parser.new
      ast = parser.parse("Feature: test")
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

    it "parses io feature" do
      parser = Parser.new
      ast = parser.parse(StringIO.new("Feature: test"))

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

    it "can parse multiple features" do
      parser = Parser.new
      ast1 = parser.parse(TokenScanner.new("Feature: test"))
      ast2 = parser.parse(TokenScanner.new("Feature: test2"))

      expect(ast1).to eq({
        type: :Feature,
        tags: [],
        location: {line: 1, column: 1},
        language: "en",
        keyword: "Feature",
        name: "test",
        scenarioDefinitions: [],
        comments: []
      })
      expect(ast2).to eq({
        type: :Feature,
        tags: [],
        location: {line: 1, column: 1},
        language: "en",
        keyword: "Feature",
        name: "test2",
        scenarioDefinitions: [],
        comments: []
      })
    end

    it "can parse feature after parse error" do
      parser = Parser.new
      matcher = TokenMatcher.new

      expect { parser.parse(TokenScanner.new("# a comment\n" +
                                             "Feature: Foo\n" +
                                             "  Scenario: Bar\n" +
                                             "    Given x\n" +
                                             "      ```\n" +
                                             "      unclosed docstring\n"),
                            matcher)
      }.to raise_error(ParserError)
      ast = parser.parse(TokenScanner.new("Feature: Foo\n" +
                                          "  Scenario: Bar\n" +
                                          "    Given x\n" +
                                          '      """' + "\n" +
                                          "      closed docstring\n" +
                                          '      """' + "\n"),
                         matcher)

      expect(ast).to eq({
        type: :Feature,
        tags: [],
        location: {line: 1, column: 1},
        language: "en",
        keyword: "Feature",
        name: "Foo",
        scenarioDefinitions: [{
          :type=>:Scenario,
          :tags=>[],
          :location=>{:line=>2, :column=>3},
          :keyword=>"Scenario",
          :name=>"Bar",
          :steps=>[{
            :type=>:Step,
            :location=>{:line=>3, :column=>5},
            :keyword=>"Given ",
            :text=>"x",
            :argument=>{:type=>:DocString,
                        :location=>{:line=>4, :column=>7},
                        :content=>"closed docstring"}}]}],
        comments: []
      })
    end

    it "can change the default language" do
      parser = Parser.new
      matcher = TokenMatcher.new("no")
      scanner = TokenScanner.new("Egenskap: i18n support")
      ast = parser.parse(scanner, matcher)
      expect(ast).to eq({
        type: :Feature,
        tags: [],
        location: {line: 1, column: 1},
        language: "no",
        keyword: "Egenskap",
        name: "i18n support",
        scenarioDefinitions: [],
        comments: []
      })
    end
  end
end
