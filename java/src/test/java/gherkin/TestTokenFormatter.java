package gherkin;

public class TestTokenFormatter {
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
                token.Location.Line,
                token.Location.Column,
                token.MatchedType,
                token.MatchedKeyword,
                token.MatchedText,
                token.MathcedItems == null ? "" : StringUtils.join(SPAN_TO_STRING, ",", token.MathcedItems)
        );
    }
}
