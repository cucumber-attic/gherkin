module Gherkin
  class Location < Struct.new(:line, :column)
    def initialize(line, column=0)
      super
    end

    def to_json(*a)
      to_h.to_json(*a)
    end
  end
end
