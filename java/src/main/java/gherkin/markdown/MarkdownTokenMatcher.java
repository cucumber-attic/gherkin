package gherkin.markdown;

import gherkin.Parser;
import gherkin.Token;
import gherkin.ast.Location;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.regex.MatchResult;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MarkdownTokenMatcher implements Parser.ITokenMatcher {
    public static final Pattern FEATURE_PATTERN = Pattern.compile("^#\\s*(.*)$");
    public static final Pattern SCENARIO_PATTERN = Pattern.compile("^#{2,4}\\s*(.*)$");
    private final Comparator<? super MatchResult> matchResultComparator = new MatchResultComparator();
    private final List<Pattern> stepdefPatterns;

    public MarkdownTokenMatcher(List<Pattern> stepdefPatterns) {
        this.stepdefPatterns = stepdefPatterns;
    }

    @Override
    public boolean match_EOF(Token token) {
        if (token.isEOF()) {
            token.matchedType = Parser.TokenType.EOF;
            return true;
        }
        return false;
    }

    @Override
    public boolean match_Empty(Token token) {
        if(match_StepLine(token) || match_ScenarioLine(token)) {
            return false;
        }
        token.matchedType = Parser.TokenType.Empty;
        return true;
    }

    @Override
    public boolean match_Comment(Token token) {
        return false; // There are no comments in Markdown - no need!
    }

    @Override
    public boolean match_TagLine(Token token) {
        return false;
    }

    @Override
    public boolean match_FeatureLine(Token token) {
        return matchMarkdownHeader(token, FEATURE_PATTERN, Parser.TokenType.FeatureLine);
    }

    private boolean matchMarkdownHeader(Token token, Pattern headerPattern, Parser.TokenType matchedType) {
        String line = token.line.getLineText(-1);

        Matcher matcher = headerPattern.matcher(line);
        if (matcher.find()) {
            MatchResult matchResult = matcher.toMatchResult();
            int start = matchResult.start(1);
            int end = matchResult.end(1);
            String text = line.substring(start, end);

            token.matchedType = matchedType;
            token.matchedKeyword = null;
            token.matchedText = text;
            token.mathcedItems = null;
            token.matchedGherkinDialect = null;
            token.matchedIndent = -1;
            token.location = new Location(token.location.getLine(), start);
            return true;
        }
        return false;
    }

    @Override
    public boolean match_BackgroundLine(Token token) {
        return false;
    }

    @Override
    public boolean match_ScenarioLine(Token token) {
        return matchMarkdownHeader(token, SCENARIO_PATTERN, Parser.TokenType.ScenarioLine);
    }

    @Override
    public boolean match_ScenarioOutlineLine(Token token) {
        return false;
    }

    @Override
    public boolean match_ExamplesLine(Token token) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean match_StepLine(Token token) {
        String line = token.line.getLineText(-1);

        List<MatchResult> matchResults = new ArrayList<>();
        for (Pattern stepdefPattern : stepdefPatterns) {
            Matcher matcher = stepdefPattern.matcher(line);
            if (matcher.find()) {
                MatchResult matchResult = matcher.toMatchResult();
                matchResults.add(matchResult);
            }
        }

        Collections.sort(matchResults, matchResultComparator);

        if (!matchResults.isEmpty()) {
            MatchResult matchResult = matchResults.get(0);
            int start = matchResult.start();
            int end = matchResult.end();
            String text = line.substring(start, end);

            token.matchedType = Parser.TokenType.StepLine;
            token.matchedKeyword = null;
            token.matchedText = text;
            token.mathcedItems = null;
            token.matchedGherkinDialect = null;
            token.matchedIndent = -1;
            token.location = new Location(token.location.getLine(), start);
            return true;
        } else {
            token.matchedType = Parser.TokenType.Empty;
            return false;
        }
    }

    @Override
    public boolean match_DocStringSeparator(Token token) {
        return false; // Maybe later, using > quoted text
    }

    @Override
    public boolean match_TableRow(Token token) {
        return false; // not yet supported
    }

    @Override
    public boolean match_Language(Token token) {
        return false;
    }

    @Override
    public boolean match_Other(Token token) {
        return false;
//        token.matchedType = Parser.TokenType.Other;
//        token.matchedText = token.line.getLineText(-1);
//        return true; // This is for description (and DocStrings). Not needed (maybe support DocString later as quoted text)
    }

    @Override
    public void reset() {
    }
}
