module Gherkin
  class ParserError < StandardError; end

  class ParserException < ParserError
    def initialize(message, location)
      super("(#{location.line_number}:#{location.column}): #{message}")
    end
  end

  class CompositeParserException < ParserError
    def initialize(errors)
      @errors = errors
      super errors.map(&:message).join("\n")
    end
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
