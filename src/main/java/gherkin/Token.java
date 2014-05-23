package gherkin;

import gherkin.ast.Location;

import java.util.List;

public class Token {
    public boolean IsEOF() {
        return Line == null;
    }

    public final IGherkinLine Line;
    public TokenType MatchedType;
    public String MatchedKeyword;
    public String MatchedText;
    public List<GherkinLineSpan> MathcedItems;
    public int MatchedIndent;
    public GherkinDialect MatchedGherkinDialect;
    public gherkin.ast.Location Location;

    public Token(IGherkinLine line, Location location) {
        Line = line;
        Location = location;
    }

    public void Detach() {
        if (Line != null)
            Line.Detach();
    }

    public String GetTokenValue() {
        return IsEOF() ? "EOF" : Line.GetLineText(-1);
    }

    public String ToString() {
        return String.format("%s: %s/%s", MatchedType, MatchedKeyword, MatchedText);
    }

}
