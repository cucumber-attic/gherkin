require 'gherkin3/token'
require 'gherkin3/gherkin_line'

module Gherkin3
  module Scanners
    class BasicScanner
      attr_reader :io

      def initialize(*)
        @line_number = 0
      end

      def read
        location = {line: @line_number += 1}
        if io.nil? || line = io.gets
          gherkin_line = line ? GherkinLine.new(line, location[:line]) : nil
          Token.new(gherkin_line, location)
        else
          io.close unless io.closed? # ARGF closes the last file after final gets
          Token.new(nil, location)
        end
      end
    end
  end
end
