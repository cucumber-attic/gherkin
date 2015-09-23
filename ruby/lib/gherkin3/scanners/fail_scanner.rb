require 'gherkin3/scanners/basic_scanner'

module Gherkin3
  module Scanners
    class FailScanner < BasicScanner
      def self.match?(*)
        fail ArgumentError, 'Please a pass "String", "Pathname", path to file as "String" or "IO".'
      end
    end
  end
end
