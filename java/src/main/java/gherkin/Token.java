package gherkin;

import gherkin.ast.Location;

import java.util.List;

public class Token {
    public boolean IsEOF() {
        return line == null;
    }

    public final IGherkinLine line;
    public Parser.TokenType matchedType;
    public String matchedKeyword;
    public String matchedText;
    public List<GherkinLineSpan> mathcedItems;
    public int matchedIndent;
    public GherkinDialect matchedGherkinDialect;
    public Location location;

    public Token(IGherkinLine line, Location location) {
        this.line = line;
        this.location = location;
    }

    public void detach() {
        if (line != null)
            line.detach();
    }

    public String getTokenValue() {
        return IsEOF() ? "EOF" : line.getLineText(-1);
    }

    @Override
    public String toString() {
        return String.format("%s: %s/%s", matchedType, matchedKeyword, matchedText);
    }

}
