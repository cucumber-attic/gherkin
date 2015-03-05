module Gherkin
  class GherkinLine
    def initialize(line_text, line_number)
      @line_text = line_text
      @line_number = line_number
      @trimmed_line_text = line_text.lstrip
      @empty = @trimmed_line_text.empty?
      @indent = @line_text.length - @trimmed_line_text.length
    end
  end
end
