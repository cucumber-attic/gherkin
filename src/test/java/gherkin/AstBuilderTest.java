package gherkin;

import gherkin.ast.Feature;
import org.junit.Test;

import java.io.StringReader;

import static org.junit.Assert.assertEquals;

public class AstBuilderTest {
    @Test
    public void is_reusable() {
        Parser<Feature> parser = new Parser<>(new AstBuilder());
        TokenMatcher matcher = new TokenMatcher();

        Feature f1 = parser.parse("Feature: 1", matcher);
        Feature f2 = parser.parse("Feature: 2", matcher);

        assertEquals("1", f1.getName());
        assertEquals("2", f2.getName());
    }
}
