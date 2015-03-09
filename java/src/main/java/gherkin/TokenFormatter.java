package gherkin;

public class TokenFormatter {
    private static final StringUtils.ToString<GherkinLineSpan> SPAN_TO_STRING = new StringUtils.ToString<GherkinLineSpan>() {
        @Override
        public String toString(GherkinLineSpan o) {
            return o.Column + ":" + o.Text;
        }
    };

    public String FormatToken(Token token) {
        if (token.IsEOF())
            return "EOF";

        return String.format("(%s:%s)%s:%s/%s/%s",
                toString(token.location.line),
                toString(token.location.column),
                toString(token.matchedType),
                toString(token.matchedKeyword),
                toString(token.matchedText),
                toString(token.mathcedItems == null ? "" : StringUtils.join(SPAN_TO_STRING, ",", token.mathcedItems))
        );
    }

    private String toString(Object o) {
        return o == null ? "" : o.toString();
    }
}
