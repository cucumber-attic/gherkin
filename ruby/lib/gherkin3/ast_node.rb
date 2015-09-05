module Gherkin3
  
  # Nodes are created by the AstBuilder, and are the building blocks of the AST (Abstract Syntax Tree).
  # Every node has a Location that describes the line number and column number in the input file.
  # These numbers are 1-indexed.
  #
  # All fields on nodes are strings (except for Location.line and Location.column).
  #
  # The implementation is simple objects without behaviour, only data.
  # It's up to the implementation to decide whether to use classes or just basic collections,
  # but the AST must have a JSON representation (this is used for testing).
  #
  # Each node in the JSON representation also has a `type` property with the name of the node type.
  class AstNode
    attr_reader :rule_type

    def initialize(rule_type)
      @rule_type = rule_type
      @_sub_items = Hash.new { |hash, key| hash[key] = [] } # returns [] for unknown key
    end

    def add(rule_type, obj)
      @_sub_items[rule_type].push(obj)
    end

    def get_single(rule_type)
      @_sub_items[rule_type].first
    end

    def get_items(rule_type)
      @_sub_items[rule_type]
    end

    def get_token(token_type)
      get_single(token_type)
    end

    def get_tokens(token_type)
      @_sub_items[token_type]
    end
  end
end
