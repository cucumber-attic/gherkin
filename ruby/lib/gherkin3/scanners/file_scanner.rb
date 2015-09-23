require 'pathname'
require 'gherkin3/scanners/basic_scanner'

module Gherkin3
  module Scanners
    class FileScanner < BasicScanner
      def initialize(input)
        super

        @io = if String === input
                File.open(input, 'r:BOM|UTF-8')
              else
                input.open
              end
      end

      def self.match?(input)
        File.file?(input.to_s) || Pathname === input
      end
    end
  end
end
