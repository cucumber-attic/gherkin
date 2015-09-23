require 'gherkin3/scanners/file_scanner'
require 'gherkin3/scanners/string_scanner'
require 'gherkin3/scanners/io_scanner'
require 'gherkin3/scanners/fail_scanner'

module Gherkin3
  # The scanner reads a gherkin doc (typically read from a .feature file) and 
  # creates a token for line. The tokens are passed to the parser, which outputs 
  # an AST (Abstract Syntax Tree).
  #
  # If the scanner sees a # language header, it will reconfigure itself dynamically 
  # to look for Gherkin keywords for the associated language. The keywords are defined 
  # in gherkin-languages.json.
  class TokenScanner
    def initialize(input)
      @line_number = 0

      @token_scanner = [
        Scanners::FileScanner,
        Scanners::StringScanner,
        Scanners::IOScanner,
        Scanners::FailScanner
      ].find { |s| s.match? input }.new(input)
    end

    # Read tokens
    def read
      @token_scanner.read
    end
  end
end
