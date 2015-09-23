require 'stringio'
require 'gherkin3/scanners/basic_scanner'

module Gherkin3
  module Scanners
    class StringScanner < BasicScanner
      def initialize(input)
        super

        @io = StringIO.new(input)
      end

      def self.match?(input)
        String === input
      end
    end
  end
end
