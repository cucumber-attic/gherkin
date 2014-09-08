package gherkin;

import gherkin.ast.Feature;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class ParserTest {
    @Test
    public void parses_simple_feature() {
        Parser parser = new Parser();
        Parser.ITokenScanner scanner = new TokenScanner("Feature: Hello");
        Feature feature = (Feature) parser.Parse(scanner);
        assertEquals("Hello", feature.getTitle());
    }

}
