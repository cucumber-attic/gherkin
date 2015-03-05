require 'gherkin/ast_node'

module Gherkin
  class AstBuilder
    attr_reader :stack

    def initialize
      @stack = [AstNode.new('None')]
    end

    def start_rule(rule_type)
      stack.push AstNode.new(rule_type)
    end

    def end_rule(rule_type)
      node = stack.pop
      current_node.add(node.rule_type, transform_node(node))
    end

    def build(token)
      current_node.add(token.matched_type, token)
    end

    def current_node
      stack.last
    end
  end
end
