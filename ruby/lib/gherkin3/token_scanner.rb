require_relative 'token'
require_relative 'gherkin_line'

module Gherkin3
  
  # The scanner reads a gherkin doc (typically read from a .feature file) and 
  # creates a token for line. The tokens are passed to the parser, which outputs 
  # an AST (Abstract Syntax Tree).
  #
  # If the scanner sees a # language header, it will reconfigure itself dynamically 
  # to look for Gherkin keywords for the associated language. The keywords are defined 
  # in gherkin-languages.json.
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
      location = {line: @line_number += 1}
      if @io.nil? || line = @io.gets
        gherkin_line = line ? GherkinLine.new(line, location[:line]) : nil
        Token.new(gherkin_line, location)
      else
        @io.close unless @io.closed? # ARGF closes the last file after final gets
        @io = nil
        Token.new(nil, location)
      end
    end

  end
end
