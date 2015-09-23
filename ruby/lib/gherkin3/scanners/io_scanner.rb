require 'gherkin3/scanners/basic_scanner'

module Gherkin3
  module Scanners
    class IOScanner < BasicScanner
      def initialize(input)
        super

        @io = input
      end

      def self.match?(input)
        input.is_a? IO
      end
    end
  end
end
