require 'gherkin/location'
require 'gherkin/token'
require 'gherkin/gherkin_line'

module Gherkin
  class TokenScanner

    def initialize(source_or_path_or_io)
      @line_number = 0
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
      location = Location.new(@line_number += 1)
      if @io.nil? || line = @io.gets
        Token.new(GherkinLine.new(line, location.line_number), location)
      else
        @io.close unless @io.closed? # ARGF closes the last file after final gets
        @io = nil
        Token.new(nil, location)
      end
    end

  end
end
