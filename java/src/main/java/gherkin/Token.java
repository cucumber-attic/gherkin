package gherkin;

public class Token {
    private final String unindentedLine;
    private final Location location;
    private final GherkinDialect dialect;
    private final int indent;

    private String keyword;
    private String text;

    public Token(String line, Location location, GherkinDialect dialect) {
        this.unindentedLine = line == null ? null : ltrim(line);
        this.indent = line == null ? 0 : line.length() - unindentedLine.length();
        this.location = location;
        this.dialect = dialect;
    }

    @Override
    public String toString() {
        TokenType type = getType();
        if (type == TokenType.EOF) return "EOF";
        return String.format("(%s)%s:%s/%s/", location, type, getKeyword() == null ? "" : getKeyword(), getText() == null ? "" : getText());
    }

    public TokenType getType() {
        if (matchEof()) {
            return TokenType.EOF;
        }
        if (matchEmpty()) {
            return TokenType.Empty;
        }
        if (matchLanguage()) {
            return TokenType.Language;
        }
        if (matchFeatureLine()) {
            return TokenType.FeatureLine;
        }
        if (matchScenarioLine()) {
            return TokenType.ScenarioLine;
        }
        if (matchesStepLine()) {
            return TokenType.StepLine;
        }
        return TokenType.Other;
    }

    public boolean matchEof() {
        return unindentedLine == null;
    }

    public boolean matchLanguage() {
        if (unindentedLine.charAt(0) == '#') {
            // eat space
            int i = 1;
            while (i < unindentedLine.length() && Character.isWhitespace(unindentedLine.charAt(i))) {
                i++;
            }
            if (unindentedLine.substring(i).startsWith("language")) {
                // eat more space
                i += 8; // length of "language"
                while (i < unindentedLine.length() && Character.isWhitespace(unindentedLine.charAt(i))) {
                    i++;
                }
                if (unindentedLine.substring(i).startsWith(":")) {
                    i += 1; // length of ":"
                    while (i < unindentedLine.length() && Character.isWhitespace(unindentedLine.charAt(i))) {
                        i++;
                    }
                    location.setColumn(indent + 1);
                    this.text = unindentedLine.substring(i).trim();
                    return true;
                }
            }
        }
        return false;
    }

    public boolean matchEmpty() {
        boolean empty = unindentedLine.equals("");
        if (empty) {
            this.location.setColumn(1);
        }
        return empty;
    }

    public boolean matchFeatureLine() {
        return matchesTitleLine(dialect.getFeatureKeywords());
    }

    public boolean matchScenarioLine() {
        return matchesTitleLine(dialect.getScenarioKeywords());
    }

    public boolean matchesStepLine() {
        for (String keyword : dialect.getStepKeywords()) {
            int stepIndex = unindentedLine.indexOf(keyword);
            if (unindentedLine.startsWith(keyword)) {
                this.location.setColumn(indent + stepIndex + 1);
                this.keyword = keyword;
                this.text = unindentedLine.substring(keyword.length()).trim();
                return true;
            }
        }
        return false;
    }

    private boolean matchesTitleLine(String[] keywords) {
        for (String keyword : keywords) {
            int stepIndex = unindentedLine.indexOf(keyword + ":"); // OPTIMIZE: don't create new string
            if (stepIndex != -1) {
                this.location.setColumn(indent + stepIndex + 1);
                this.keyword = keyword;
                this.text = unindentedLine.substring(keyword.length() + 1).trim();
                return true;
            }
        }
        return false;
    }

    public String getKeyword() {
        return keyword;
    }

    public String getText() {
        return text;
    }

    private static String ltrim(String s) {
        int i = 0;
        while (i < s.length() && Character.isWhitespace(s.charAt(i))) {
            i++;
        }
        return s.substring(i);
    }
}
