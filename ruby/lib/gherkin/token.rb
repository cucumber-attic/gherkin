module Gherkin
  class Token
    attr_reader :line
    def initialize(line, location)
      @line = line
      @location = location
    end

    def eof?
      @line.nil?
    end
  end
end
