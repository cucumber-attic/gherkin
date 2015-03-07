package gherkin;

import gherkin.ast.Location;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static gherkin.Parser.ITokenMatcher;
import static gherkin.Parser.TokenType;

public class TokenMatcher implements ITokenMatcher {
    private static final Pattern LANGUAGE_PATTERN = Pattern.compile("^\\s*#\\s*language\\s*:\\s*([a-zA-Z\\-_]+)\\s*$");
    private final IGherkinDialectProvider dialectProvider;
    private GherkinDialect currentDialect;
    private String activeDocStringSeparator = null;
    private int indentToRemove = 0;

    public TokenMatcher(IGherkinDialectProvider dialectProvider) {
        this.dialectProvider = dialectProvider;
        currentDialect = dialectProvider.getDefaultDialect();
    }

    public TokenMatcher() {
        this(new GherkinDialectProvider());
    }

    public GherkinDialect getCurrentDialect() {
        return currentDialect;
    }

    protected void SetTokenMatched(Token token, TokenType matchedType, String text, String keyword, Integer indent, List<GherkinLineSpan> items) {
        token.MatchedType = matchedType;
        token.MatchedKeyword = keyword;
        token.MatchedText = text;
        token.MathcedItems = items;
        token.MatchedGherkinDialect = getCurrentDialect();
        token.MatchedIndent = indent != null ? indent : (token.Line == null ? 0 : token.Line.Indent());
        token.Location = new Location(token.Location.Line, token.MatchedIndent + 1);
    }

    private void SetTokenMatched(Token token, TokenType tokenType) {
        SetTokenMatched(token, tokenType, null, null, null, null);
    }

    @Override
    public boolean Match_EOF(Token token) {
        if (token.IsEOF()) {
            SetTokenMatched(token, TokenType.EOF);
            return true;
        }
        return false;
    }

    @Override
    public boolean Match_Other(Token token) {
        String text = token.Line.GetLineText(indentToRemove); //take the entire line, except removing DocString indents
        SetTokenMatched(token, TokenType.Other, text, null, 0, null);
        return true;
    }

    @Override
    public boolean Match_Empty(Token token) {
        if (token.Line.IsEmpty()) {
            SetTokenMatched(token, TokenType.Empty);
            return true;
        }
        return false;
    }

    @Override
    public boolean Match_Comment(Token token) {
        if (token.Line.StartsWith(GherkinLanguageConstants.COMMENT_PREFIX)) {
            String text = token.Line.GetLineText(0); //take the entire line
            SetTokenMatched(token, TokenType.Comment, text, null, 0, null);
            return true;
        }
        return false;
    }

    private ParserException CreateTokenMatcherException(Token token, String message) {
        return new ParserException.AstBuilderException(message, new Location(token.Location.Line, token.Line.Indent() + 1));
    }

    @Override
    public boolean Match_Language(Token token) {
        Matcher matcher = LANGUAGE_PATTERN.matcher(token.Line.GetLineText(0));
        if(matcher.matches()) {
            String language = matcher.group(1);

            currentDialect = dialectProvider.GetDialect(language);

            SetTokenMatched(token, TokenType.Language, language, null, null, null);
            return true;
        }
        return false;
    }

    @Override
    public boolean Match_TagLine(Token token) {
        if (token.Line.StartsWith(GherkinLanguageConstants.TAG_PREFIX)) {
            SetTokenMatched(token, TokenType.TagLine, null, null, null, token.Line.GetTags());
            return true;
        }
        return false;
    }

//    public boolean matchTagLine(Token token) {
//        if (unindentedLine.charAt(0) == '@') {
//            lineSpans = new ArrayList<LineSpan>();
//
//            location.setColumn(indent + 1);
//
//            // TODO: Consider simpler Scanner based implementation like in matchTableRow()
//            int col = 0;
//            int tagStart = -1;
//            while (col < unindentedLine.length()) {
//                if (Character.isWhitespace(unindentedLine.charAt(col))) {
//                    if (tagStart > -1) {
//                        String tag = unindentedLine.substring(tagStart, col);
//                        lineSpans.add(new LineSpan(tagStart + indent + 1, tag));
//                        tagStart = -1;
//                    }
//                } else {
//                    if (tagStart == -1) {
//                        tagStart = col;
//                    }
//                }
//                col++;
//            }
//            if (tagStart > -1) {
//                String tag = unindentedLine.substring(tagStart, col);
//                lineSpans.add(new LineSpan(tagStart + indent + 1, tag));
//            }
//            return true;
//        }
//        return false;
//    }

    @Override
    public boolean Match_FeatureLine(Token token) {
        return MatchTitleLine(token, TokenType.FeatureLine, currentDialect.getFeatureKeywords());
    }

    @Override
    public boolean Match_BackgroundLine(Token token) {
        return MatchTitleLine(token, TokenType.BackgroundLine, currentDialect.getBackgroundKeywords());
    }

    @Override
    public boolean Match_ScenarioLine(Token token) {
        return MatchTitleLine(token, TokenType.ScenarioLine, currentDialect.getScenarioKeywords());
    }

    @Override
    public boolean Match_ScenarioOutlineLine(Token token) {
        return MatchTitleLine(token, TokenType.ScenarioOutlineLine, currentDialect.getScenarioOutlineKeywords());
    }

    @Override
    public boolean Match_ExamplesLine(Token token) {
        return MatchTitleLine(token, TokenType.ExamplesLine, currentDialect.getExamplesKeywords());
    }

    private boolean MatchTitleLine(Token token, TokenType tokenType, String[] keywords) {
        for (String keyword : keywords) {
            if (token.Line.StartsWithTitleKeyword(keyword)) {
                String title = token.Line.GetRestTrimmed(keyword.length() + GherkinLanguageConstants.TITLE_KEYWORD_SEPARATOR.length());
                SetTokenMatched(token, tokenType, title, keyword, null, null);
                return true;
            }
        }
        return false;
    }

    public boolean Match_DocStringSeparator(Token token) {
        return activeDocStringSeparator == null
                // open
                ? Match_DocStringSeparator(token, GherkinLanguageConstants.DOCSTRING_SEPARATOR, true) ||
                Match_DocStringSeparator(token, GherkinLanguageConstants.DOCSTRING_ALTERNATIVE_SEPARATOR, true)
                // close
                : Match_DocStringSeparator(token, activeDocStringSeparator, false);
    }

    private boolean Match_DocStringSeparator(Token token, String separator, boolean isOpen) {
        if (token.Line.StartsWith(separator)) {
            String contentType = null;
            if (isOpen) {
                contentType = token.Line.GetRestTrimmed(separator.length());
                activeDocStringSeparator = separator;
                indentToRemove = token.Line.Indent();
            } else {
                activeDocStringSeparator = null;
                indentToRemove = 0;
            }

            SetTokenMatched(token, TokenType.DocStringSeparator, contentType, null, null, null);
            return true;
        }
        return false;
    }

    @Override
    public boolean Match_StepLine(Token token) {
        String[] keywords = currentDialect.getStepKeywords();
        for (String keyword : keywords) {
            if (token.Line.StartsWith(keyword)) {
                String stepText = token.Line.GetRestTrimmed(keyword.length());
                SetTokenMatched(token, TokenType.StepLine, stepText, keyword, null, null);
                return true;
            }
        }
        return false;
    }

    public boolean Match_TableRow(Token token) {
        if (token.Line.StartsWith(GherkinLanguageConstants.TABLE_CELL_SEPARATOR)) {
            SetTokenMatched(token, TokenType.TableRow, null, null, null, token.Line.GetTableCells());
            return true;
        }
        return false;
    }

//    public boolean matchTableRow(Token token) {
//        if (unindentedLine.charAt(0) == '|') {
//            lineSpans = new ArrayList<LineSpan>();
//            location.setColumn(indent + 1);
//            Scanner scanner = new Scanner(unindentedLine).useDelimiter("\\s*\\|\\s*");
//            while (scanner.hasNext()) {
//                String cell = scanner.next();
//                int column = scanner.match().start() + indent + 1;
//                lineSpans.add(new LineSpan(column, cell));
//            }
//            return true;
//        }
//        return false;
//    }

//    public boolean matchLanguage(Token token) {
//        if (unindentedLine.charAt(0) == '#') {
//            // eat space
//            int i = 1;
//            while (i < unindentedLine.length() && Character.isWhitespace(unindentedLine.charAt(i))) {
//                i++;
//            }
//            if (unindentedLine.substring(i).startsWith("language")) {
//                // eat more space
//                i += 8; // length of "language"
//                while (i < unindentedLine.length() && Character.isWhitespace(unindentedLine.charAt(i))) {
//                    i++;
//                }
//                if (unindentedLine.substring(i).startsWith(":")) {
//                    i += 1; // length of ":"
//                    while (i < unindentedLine.length() && Character.isWhitespace(unindentedLine.charAt(i))) {
//                        i++;
//                    }
//                    location.setColumn(indent + 1);
//                    this.text = unindentedLine.substring(i).trim();
//                    return true;
//                }
//            }
//        }
//        return false;
//    }

//    public boolean matchesStepLine(Token token) {
//        for (String keyword : dialect.getStepKeywords()) {
//            int stepIndex = unindentedLine.indexOf(keyword);
//            if (unindentedLine.startsWith(keyword)) {
//                this.location.setColumn(indent + stepIndex + 1);
//                this.keyword = keyword;
//                this.text = unindentedLine.substring(keyword.length()).trim();
//                return true;
//            }
//        }
//        return false;
//    }
//
//    private boolean matchesTitleLine(String[] keywords) {
//        for (String keyword : keywords) {
//            int stepIndex = unindentedLine.indexOf(keyword + ":"); // OPTIMIZE: don't create new string
//            if (stepIndex != -1) {
//                this.location.setColumn(indent + stepIndex + 1);
//                this.keyword = keyword;
//                this.text = unindentedLine.substring(keyword.length() + 1).trim();
//                return true;
//            }
//        }
//        return false;
//    }
}
