module Gherkin
  class ParserException < StandardError
    def initialize(message, location)
      super("(#{location.line_number}:#{location.column}): #{message}")
    end
  end

  class CompositeParserException < ParserException
  end

  class UnexpectedTokenException < ParserException
    def initialize(received_token, expected_token_types, state_comment)
      message = "expected: #{expected_token_types.join(", ")}, got '#{received_token.get_token_value.strip}'"
      super(message, received_token.location)
    end
  end

  class UnexpectedEOFException < UnexpectedTokenException
  end
end
