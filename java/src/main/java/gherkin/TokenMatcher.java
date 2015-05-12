package gherkin;

import gherkin.ast.Location;

import java.util.List;

import static gherkin.Parser.ITokenMatcher;
import static gherkin.Parser.TokenType;

public abstract class TokenMatcher implements ITokenMatcher {
    protected final IGherkinDialectProvider dialectProvider = new GherkinDialectProvider();
    protected GherkinDialect currentDialect = dialectProvider.getDefaultDialect();

    public GherkinDialect getCurrentDialect() {
        return currentDialect;
    }

    protected void setTokenMatched(Token token, TokenType matchedType, String text, String keyword, Integer indent, List<GherkinLineSpan> items) {
        token.matchedType = matchedType;
        token.matchedKeyword = keyword;
        token.matchedText = text;
        token.mathcedItems = items;
        token.matchedGherkinDialect = getCurrentDialect();
        token.matchedIndent = indent != null ? indent : (token.line == null ? 0 : token.line.indent());
        token.location = new Location(token.location.getLine(), token.matchedIndent + 1);
    }

    @Override
    public boolean match_Empty(Token token) {
        if (token.line.isEmpty()) {
            setTokenMatched(token, Parser.TokenType.Empty, null, null, null, null);
            return true;
        }
        return false;
    }


    @Override
    public boolean match_EOF(Token token) {
        if (token.isEOF()) {
            setTokenMatched(token, TokenType.EOF, null, null, null, null);
            return true;
        }
        return false;
    }

}
