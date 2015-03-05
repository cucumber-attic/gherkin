module Gherkin
  class Location < Struct.new(:line_number, :column)
    def initialize(line_number, column=0)
      super
    end
  end
end
