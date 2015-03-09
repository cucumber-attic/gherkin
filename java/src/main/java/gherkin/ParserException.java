package gherkin;

import gherkin.ast.Location;

import java.util.List;

public class ParserException extends RuntimeException {
    public Location location;

    protected ParserException(String message) {
        super(message);
    }

    protected ParserException(String message, Location location) {
        super(GetMessage(message, location));
        if (location == null) throw new NullPointerException("location");

        this.location = location;
    }

    private static String GetMessage(String message, Location location) {
        if (location == null) throw new NullPointerException("location");

        return String.format("(%s:%s): %s", location.line, location.column, message);
    }

    public static class AstBuilderException extends ParserException {
        public AstBuilderException(String message) {
            super(message);
            if (message == null) throw new NullPointerException("message");
        }

        public AstBuilderException(String message, Location location) {
            super(message, location);
        }
    }

    public static class UnexpectedTokenException extends ParserException {
        public String StateComment;

        public final Token ReceivedToken;
        public final List<String> ExpectedTokenTypes;

        public UnexpectedTokenException(Token receivedToken, List<String> expectedTokenTypes, String stateComment) {
            super(GetMessage(receivedToken, expectedTokenTypes), receivedToken.location);
            ReceivedToken = receivedToken;
            ExpectedTokenTypes = expectedTokenTypes;
            StateComment = stateComment;
        }

        private static String GetMessage(Token receivedToken, List<String> expectedTokenTypes) {
            if (receivedToken == null) throw new NullPointerException("receivedToken");
            if (expectedTokenTypes == null) throw new NullPointerException("expectedTokenTypes");

            return String.format("expected: %s, got '%s'",
                    StringUtils.join(", ", expectedTokenTypes),
                    receivedToken.getTokenValue().trim());
        }
    }

    public static class UnexpectedEOFException extends ParserException {
        public final String StateComment;
        public final List<String> ExpectedTokenTypes;

        public UnexpectedEOFException(Token receivedToken, List<String> expectedTokenTypes, String stateComment) {
            super(GetMessage(expectedTokenTypes), receivedToken.location);
            ExpectedTokenTypes = expectedTokenTypes;
            StateComment = stateComment;
        }

        private static String GetMessage(List<String> expectedTokenTypes) {
            if (expectedTokenTypes == null) throw new NullPointerException("expectedTokenTypes");

            return String.format("unexpected end of file, expected: %s",
                    StringUtils.join(", ", expectedTokenTypes));
        }
    }

    public static class CompositeParserException extends ParserException {
        public final List<ParserException> Errors;

        public CompositeParserException(List<ParserException> errors) {
            super(GetMessage(errors));
            if (errors == null) throw new NullPointerException("errors");

            Errors = errors;
        }

        private static String GetMessage(List<ParserException> errors) {
            if (errors == null) throw new NullPointerException("errors");

            StringUtils.ToString<ParserException> exceptionToString = new StringUtils.ToString<ParserException>() {
                @Override
                public String toString(ParserException e) {
                    return e.getMessage();
                }
            };
            return "Parser errors: \n" + StringUtils.join(exceptionToString, "\n", errors);
        }
    }
}
