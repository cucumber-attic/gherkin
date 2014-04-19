package gherkin;

public class Token {
    private final String unindentedLine;
    private final Location location;
    private final GherkinDialect dialect;
    private final int indent;

    private String keyword;
    private String text;

    public Token(String line, Location location, GherkinDialect dialect) {
        this.unindentedLine = ltrim(line);
        this.indent = line.length() - unindentedLine.length();
        this.location = location;
        this.dialect = dialect;
    }

    @Override
    public String toString() {
        TokenType type = getType();
        return String.format("(%s)%s:%s/%s/", location, type, getKeyword() == null ? "" : getKeyword(), getText() == null ? "" : getText());
    }

    public TokenType getType() {
        if (matchEmpty()) {
            return TokenType.Empty;
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
