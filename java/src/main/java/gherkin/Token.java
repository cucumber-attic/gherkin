package gherkin;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Token {
    private final String line;
    private final String unindentedLine;
    private final Location location;
    private final GherkinDialect dialect;
    private final int indent;

    private String keyword;
    private String text;
    private List<LineSpan> lineSpans;

    public Token(String line, Location location, GherkinDialect dialect) {
        this.line = line;
        this.unindentedLine = line == null ? null : ltrim(line);
        this.indent = line == null ? 0 : line.length() - unindentedLine.length();
        this.location = location;
        this.dialect = dialect;
    }

    @Override
    public String toString() {
        TokenType type = getType();
        if (type == TokenType.EOF) return "EOF";
        return String.format("(%s)%s:%s/%s/%s", location, type, getKeyword(), getText(), getLineSpansAsText());
    }

    private String getLineSpansAsText() {
        if (lineSpans != null) {
            StringBuilder sb = new StringBuilder();
            boolean comma = false;
            for (LineSpan lineSpan : lineSpans) {
                if (comma) sb.append(",");
                sb.append(lineSpan);
                comma = true;
            }
            return sb.toString();
        } else {
            return "";
        }
    }

    public TokenType getType() {
        if (matchEof()) {
            return TokenType.EOF;
        } else if (matchEmpty()) {
            return TokenType.Empty;
        } else if (matchComment()) {
            return TokenType.Comment;
        } else if (matchLanguage()) {
            return TokenType.Language;
        } else if (matchTagLine()) {
            return TokenType.TagLine;
        } else if (matchTableRow()) {
            return TokenType.TableRow;
        } else if (matchFeatureLine()) {
            return TokenType.FeatureLine;
        } else if (matchBackgroundLine()) {
            return TokenType.BackgroundLine;
        } else if (matchScenarioLine()) {
            return TokenType.ScenarioLine;
        } else if (matchScenarioOutlineLine()) {
            return TokenType.ScenarioOutlineLine;
        } else if (matchExamplesLine()) {
            return TokenType.ExamplesLine;
        } else if (matchesStepLine()) {
            return TokenType.StepLine;
        } else {
            return matchOther();
        }
    }

    private TokenType matchOther() {
        this.text = line;
        this.location.setColumn(1);
        return TokenType.Other;
    }

    public boolean matchEof() {
        return unindentedLine == null;
    }

    public boolean matchComment() {
        if (unindentedLine.charAt(0) == '#') {
            location.setColumn(1);
            this.text = line;
            return true;
        }
        return false;
    }

    public boolean matchTagLine() {
        if (unindentedLine.charAt(0) == '@') {
            lineSpans = new ArrayList<LineSpan>();

            location.setColumn(indent + 1);

            // TODO: Consider simpler Scanner based implementation like in matchTableRow()
            int col = 0;
            int tagStart = -1;
            while (col < unindentedLine.length()) {
                if (Character.isWhitespace(unindentedLine.charAt(col))) {
                    if (tagStart > -1) {
                        String tag = unindentedLine.substring(tagStart, col);
                        lineSpans.add(new LineSpan(tagStart + indent + 1, tag));
                        tagStart = -1;
                    }
                } else {
                    if (tagStart == -1) {
                        tagStart = col;
                    }
                }
                col++;
            }
            if (tagStart > -1) {
                String tag = unindentedLine.substring(tagStart, col);
                lineSpans.add(new LineSpan(tagStart + indent + 1, tag));
            }
            return true;
        }
        return false;
    }

    public boolean matchTableRow() {
        if (unindentedLine.charAt(0) == '|') {
            lineSpans = new ArrayList<LineSpan>();
            location.setColumn(indent + 1);
            Scanner scanner = new Scanner(unindentedLine).useDelimiter("\\s*\\|\\s*");
            while (scanner.hasNext()) {
                String cell = scanner.next();
                int column = scanner.match().start() + indent + 1;
                lineSpans.add(new LineSpan(column, cell));
            }
            return true;
        }
        return false;
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

    public boolean matchBackgroundLine() {
        return matchesTitleLine(dialect.getBackgroundKeywords());
    }

    public boolean matchScenarioOutlineLine() {
        return matchesTitleLine(dialect.getScenarioOutlineKeywords());
    }

    public boolean matchExamplesLine() {
        return matchesTitleLine(dialect.getExamplesKeywords());
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
        return keyword == null ? "" : keyword;
    }

    public String getText() {
        return text == null ? "" : text;
    }

    private static String ltrim(String s) {
        int i = 0;
        while (i < s.length() && Character.isWhitespace(s.charAt(i))) {
            i++;
        }
        return s.substring(i);
    }
}
