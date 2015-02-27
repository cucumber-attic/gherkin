module Gherkin
  class ParserException < StandardError
    def initialize(message, location)
      super(get_message(message, location))
      @location = location
    end

    private
    def get_message(message, location)
      "(#{location.line}:#{location.column}): #{message}"
    end
  end

  class CompositeParserException < ParserException
  end
end
