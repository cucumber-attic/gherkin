module Gherkin

  class ParseError < StandardError
  end

  class GherkinDialect
    attr_accessor :feature_keywords
    attr_accessor :background_keywords
    attr_accessor :scenario_keywords
    attr_accessor :scenario_outline_keywords
    attr_accessor :examples_keywords
    attr_accessor :step_keywords

    def initialize
      @feature_keywords = ['Feature:'];
      @background_keywords = ['Background:'];
      @scenario_keywords = ['Scenario:'];
      @scenario_outline_keywords = ['Scenario Outline:', 'Scenario Template:'];
      @examples_keywords = ['Examples:', 'Scenarios:'];
      @step_keywords = ['Given ', 'When ', 'Then ', 'And ', 'But ', '* '];
    end
  end

  class Token
    attr_accessor :trimmed_line

    def initialize(line)
      @line = line
      @trimmed_line = line == nil ? nil : line.strip
    end

    def eof?
      @line == nil
    end

    def to_s
      @trimmed_line
    end

    def detach
    end
  end

  class TokenMatcher

    def initialize
      @dialect = GherkinDialect.new
    end

    def match_TagLine(token)
      token.trimmed_line.start_with?('@')
    end

    def match_Feature(token)
      start_with_any?(token.trimmed_line, @dialect.feature_keywords)
    end

    def match_Scenario(token)
      start_with_any?(token.trimmed_line, @dialect.scenario_keywords)
    end

    def match_ScenarioOutline(token)
      start_with_any?(token.trimmed_line, @dialect.scenario_outline_keywords)
    end

    def match_Background(token)
      start_with_any?(token.trimmed_line, @dialect.background_keywords)
    end

    def match_Examples(token)
      start_with_any?(token.trimmed_line, @dialect.examples_keywords)
    end

    def match_TableRow(token)
      token.trimmed_line.start_with?('|')
    end

    def match_Empty(token)
      #token.trimmed_line != nil &&
      token.trimmed_line.empty?
    end

    def match_Comment(token)
      token.trimmed_line.start_with?('#')
    end

    def match_MultiLineArgument(token)
      token.trimmed_line == '"""'
    end

    def match_EOF(token)
      token.eof?
    end

    def match_Step(token)
      start_with_any?(token.trimmed_line, @dialect.step_keywords)
    end

    def match_Other(token)
      true
    end

  private

    def start_with_any?(text, alternatives)
      alternatives.detect do |alt|
        text.start_with?(alt)
      end
    end
  end

  class TokenScanner

    def initialize(file_path)
      @file = File.open(file_path, 'r:BOM|UTF-8')
    end

    def read
      if @file == nil || line = @file.gets
        Token.new(line)
      else
        @file.close
        @file = nil
        Token.new(nil)
      end
    end
  end

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

    def root_node?
      @stack.first[0]
    end
  end
end
