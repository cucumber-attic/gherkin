module Gherkin
  class AstNode
    attr_reader :rule_type

    def initialize(rule_type)
      @rule_type = rule_type
      @_sub_items = Hash.new { |hash, key| hash[key] = [] }
    end

    def add(rule_type, obj)
      @_sub_items[rule_type].push(obj)
    end
  end
end
