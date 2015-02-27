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

    def match_FeatureLine(token)
      start_with_any?(token.trimmed_line, @dialect.feature_keywords)
    end

    def match_ScenarioLine(token)
      start_with_any?(token.trimmed_line, @dialect.scenario_keywords)
    end

    def match_ScenarioOutlineLine(token)
      start_with_any?(token.trimmed_line, @dialect.scenario_outline_keywords)
    end

    def match_BackgroundLine(token)
      start_with_any?(token.trimmed_line, @dialect.background_keywords)
    end

    def match_ExamplesLine(token)
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

    def match_Language(token)
      token.trimmed_line.start_with?('#language:')
    end

    def match_DocStringSeparator(token)
      #TODO: better pair matching
      token.trimmed_line.start_with?('"""') || token.trimmed_line.start_with?('```')
    end

    def match_EOF(token)
      token.eof?
    end

    def match_StepLine(token)
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

    def initialize(source_or_path_or_io)
      if String === source_or_path_or_io
        if File.file?(source_or_path_or_io)
          @io = File.open(source_or_path_or_io, 'r:BOM|UTF-8')
        else
          @io = StringIO.new(source_or_path_or_io)
        end
      else
        @io = source_or_path_or_io
      end
    end

    def read
      if @io.nil? || line = @io.gets
        Token.new(line)
      else
        @io.close unless @io.closed? # ARGF closes the last file after final gets
        @io = nil
        Token.new(nil)
      end
    end

  end
end
