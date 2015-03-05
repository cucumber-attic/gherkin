require 'gherkin/dialect'

module Gherkin
  class TokenMatcher
    attr_reader :dialect

    def initialize(dialect_name = 'en')
      @dialect_name = dialect_name
      @dialect = Dialect.for(@dialect_name)
    end

    def match_TagLine(token)
      return false unless token.line.start_with?('@')

      set_token_matched(token, 'TagLine', null, null, null, token.line.tags)
      true
    end

    def match_FeatureLine(token)
      match_title_line(token, 'FeatureLine', dialect.feature)
    end

    def match_ScenarioLine(token)
      match_title_line(token, 'ScenarioLine', dialect.scenario)
    end

    def match_ScenarioOutlineLine(token)
      match_title_line(token, 'ScenarioOutlineLine', dialect.scenario_outline)
    end

    def match_BackgroundLine(token)
      match_title_line(token, 'BackgroundLine', dialect.background)
    end

    def match_ExamplesLine(token)
      match_title_line(token, 'ExamplesLine', dialect.examples)
    end

    def match_Empty(token)
      return false unless token.line.empty?
      set_token_matched(token, 'Empty', nil, nil, 0)
      return true
    end

    def match_Language(token)
      return false unless token.line.start_with?('#language:')

      @dialect_name = token.line.get_rest_trimmed('#language:'.length)
      @dialec = Dialect.for(@dialect_name)
      raise "Unknown dialect: #{@dialect_name}" unless dialect
      set_token_matched(token, 'Language', @dialect_name)
      true
    end

    def match_EOF(token)
      return false unless token.eof?
      set_token_matched(token, 'EOF')
      return true
    end

    private
    def match_title_line(token, token_type, keywords)
      keyword = detect_keyword(token.line, keywords)

      return false unless keyword

      title = token.line.get_rest_trimmed(keyword.length + ':'.length)
      set_token_matched(token, token_type, title, keyword)
      return true
    end

    def set_token_matched(token, matched_type, text=nil, keyword=nil, indent=nil, items=[])
      token.matched_type = matched_type
      token.matched_text = text
      token.matched_keyword = keyword
      token.matched_indent = indent || (token.line && token.line.indent) || 0
      token.matched_items = items
      token.location.column = token.matched_indent + 1
      token.matched_gherkin_dialect = @dialect_name
    end

    def detect_keyword(line, keywords)
      keywords.detect { |k| line.start_with_title_keyword?(k) }
    end
  end
end
