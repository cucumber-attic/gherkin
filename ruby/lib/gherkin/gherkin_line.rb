module Gherkin
  class GherkinLine
    attr_reader :indent
    def initialize(line_text, line_number)
      @line_text = line_text
      @line_number = line_number
      @trimmed_line_text = line_text.lstrip
      @indent = @line_text.length - @trimmed_line_text.length
    end

    def start_with?(prefix)
      @trimmed_line_text.start_with?(prefix)
    end

    def start_with_title_keyword?(keyword)
      start_with?(keyword+':') # The C# impl is more complicated. Find out why.
    end

    def get_rest_trimmed(length)
      @trimmed_line_text[length..-1].strip
    end

    def empty?
      @trimmed_line_text.empty?
    end
  end
end
