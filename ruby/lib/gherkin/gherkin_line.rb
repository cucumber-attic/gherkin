module Gherkin
  class GherkinLine
    attr_reader :indent
    def initialize(line_text, line_number)
      @line_text = line_text
      @line_number = line_number
      @trimmed_line_text = @line_text.lstrip
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

    def get_line_text(indent_to_remove)
      indent_to_remove ||= 0
      if indent_to_remove < 0 || indent_to_remove > indent
        @trimmed_line_text
      else
        @line_text[indent_to_remove..-1]
      end
    end

    def table_cells
      column = @indent + 1
      items = @trimmed_line_text.split('|')
      items = items[1..-2] # Skip space before and after outer |
      items.map do |item|
        cell_indent = item.length - item.lstrip.length + 1
        span = Span.new(column + cell_indent, item.strip)
        column += item.length + 1
        span
      end
    end

    def tags
      column = @indent + 1;
      items = @trimmed_line_text.strip.split('@')
      items = items[1..-1] # ignore before the first @
      items.map do |item|
        length = item.length
        span = Span.new(column + cell_indent, '@' + item.strip)
        column += length + 1
        return span;
      end
    end

    class Span < Struct.new(:column, :text); end
  end
end
