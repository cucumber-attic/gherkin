require 'gherkin/parser'
require 'gherkin/token_scanner'
require 'gherkin/token_matcher'
require 'gherkin/ast_builder'
require 'json'
require 'rspec'

module Gherkin
  describe Parser do
    it "parses a simple feature" do
      parser = Gherkin::Parser.new
      scanner = Gherkin::TokenScanner.new("Feature: test")
      builder = Gherkin::AstBuilder.new
      ast = parser.parse(scanner, builder, Gherkin::TokenMatcher.new)
      expect(ast).to eq({
        :type=>:Feature,
        :tags=>[],
        :location=>{:line=>1, :column=>1},
        :language=>"en",
        :keyword=>"Feature",
        :name=>"test",
        :scenarioDefinitions=>[]
      })
    end
  end
end
