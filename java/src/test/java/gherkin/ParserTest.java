package gherkin;

import gherkin.ast.Feature;
import gherkin.ast.Scenario;
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

    @Test
    public void parses_feature_with_scenario_and_steps() {
        Parser parser = new Parser();
        Parser.ITokenScanner scanner = new TokenScanner("" +
                "Feature: Hello\n" +
                "  The Description\n" +
                "\n" +
                "  Scenario: World\n" +
                "    Given I have 4 cukes");
        Feature feature = (Feature) parser.Parse(scanner);
        assertEquals("Hello", feature.getTitle());

        Scenario scenario = (Scenario) feature.getScenarioDefinitions().get(0);
        assertEquals("World", scenario.getTitle());
    }
}
