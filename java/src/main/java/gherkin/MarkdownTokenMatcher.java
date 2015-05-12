package gherkin;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MarkdownTokenMatcher extends TokenMatcher {

    public static final Pattern FEATURE_PATTERN = Pattern.compile("^(#\\s*)([^#].*)");
    public static final Pattern SCENARIO_PATTERN = Pattern.compile("^(##\\s*)([^#].*)");
    public static final Pattern STEP_PATTERN = Pattern.compile("^(\\*\\s*)([^\\*].*)");

    @Override
    public boolean match_Comment(Token token) {
        return false; // We don't support comments in Markdown
    }

    @Override
    public boolean match_TagLine(Token token) {
        // TODO
        return false;
    }

    @Override
    public boolean match_FeatureLine(Token token) {
        Matcher matcher = FEATURE_PATTERN.matcher(token.line.getLineText(0));
        if(matcher.matches()) {
            String keyword = matcher.group(1);
            String text = matcher.group(2);
            setTokenMatched(token, Parser.TokenType.FeatureLine, text, keyword, 0, null);
            return true;
        }
        return false;
    }

    @Override
    public boolean match_BackgroundLine(Token token) {
        // We don't support Background in Markdown, at least not yet.
        // Maybe we could implement it using italics:
        // ## _This is a background_
        return false;
    }

    @Override
    public boolean match_ScenarioLine(Token token) {
        Matcher matcher = SCENARIO_PATTERN.matcher(token.line.getLineText(0));
        if(matcher.matches()) {
            String keyword = matcher.group(1);
            String text = matcher.group(2);
            setTokenMatched(token, Parser.TokenType.ScenarioLine, text, keyword, 0, null);
            return true;
        }
        return false;
    }

    @Override
    public boolean match_ScenarioOutlineLine(Token token) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean match_ExamplesLine(Token token) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean match_StepLine(Token token) {
        Matcher matcher = STEP_PATTERN.matcher(token.line.getLineText(0));
        if(matcher.matches()) {
            String keyword = matcher.group(1);
            String text = matcher.group(2);
            setTokenMatched(token, Parser.TokenType.StepLine, text, keyword, 0, null);
            return true;
        }
        return false;
    }

    @Override
    public boolean match_DocStringSeparator(Token token) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean match_TableRow(Token token) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean match_Language(Token token) {
        // TODO
        return false;
    }

    @Override
    public boolean match_Other(Token token) {
        throw new UnsupportedOperationException();
    }
}
