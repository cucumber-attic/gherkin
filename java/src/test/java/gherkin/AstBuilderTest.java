package gherkin;

import gherkin.ast.GherkinDocument;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class AstBuilderTest {
    @Test
    public void is_reusable() {
        Parser<GherkinDocument> parser = new Parser<>(new AstBuilder());
        TokenMatcher matcher = new TokenMatcher();

        GherkinDocument d1 = parser.parse("Feature: 1", matcher);
        GherkinDocument d2 = parser.parse("Feature: 2", matcher);

        assertEquals("1", d1.getFeature().getName());
        assertEquals("2", d2.getFeature().getName());
    }
}
