module Gherkin
  class ASTBuilder

    def initialize
      @stack = []
      push(:root)
    end

    def push(rule)
      @stack.push([])
    end

    def build(token)
      @stack.last.push(token)
    end

    def pop(rule)
      node = @stack.pop
      @stack.last.push(node)
    end

    def root_node
      @stack.first.first
    end
  end
end
