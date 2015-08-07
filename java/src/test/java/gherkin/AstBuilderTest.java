package gherkin;

import gherkin.ast.Feature;
import org.junit.Test;

import java.io.StringReader;

import static org.junit.Assert.assertEquals;

public class AstBuilderTest {
    @Test
    public void is_reusable() {
        Parser<Feature> parser = new Parser<>(new AstBuilder());

        Feature f1 = parser.parse(new StringReader("Feature: 1"));
        Feature f2 = parser.parse(new StringReader("Feature: 2"));

        assertEquals("1", f1.getName());
        assertEquals("2", f2.getName());
    }
}
