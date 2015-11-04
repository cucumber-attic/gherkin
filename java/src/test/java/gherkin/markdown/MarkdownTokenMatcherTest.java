package gherkin.markdown;

import gherkin.AstBuilder;
import gherkin.TokenScanner;
import gherkin.Parser;
import gherkin.ast.Feature;
import gherkin.deps.com.google.gson.Gson;
import org.junit.Test;

import java.util.regex.Pattern;

import static java.util.Arrays.asList;

public class MarkdownTokenMatcherTest {
    @Test
    public void recognises_tokens_based_on_patterns() {
        Parser.ITokenScanner scanner = new TokenScanner("" +
                "# This is Markdown\n" +
                "Here, I can say anything as long as it's not\n" +
                "matched as a step, because\n" +
                "we're not in a\n" +
                "Scenario yet.\n" +
                "\n" +
                "## This however, is a scenario\n" +
                "So,\n" +
                "suppose I have 5 cukes in my belly\n" +
                "for example,\n" +
                "and one day I eat another one."
        );

        Parser.ITokenMatcher matcher = new MarkdownTokenMatcher(asList(
                Pattern.compile("I eat another one"),
                Pattern.compile("I have (\\d+) cukes")));

        Parser<Feature> parser = new Parser<>(new AstBuilder());
        Feature feature = parser.parse(scanner, matcher);
        String json = new Gson().toJson(feature);
        System.out.println(json);
    }
}
