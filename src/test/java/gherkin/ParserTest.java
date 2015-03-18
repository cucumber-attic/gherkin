package gherkin;

import gherkin.ast.DataTable;
import gherkin.ast.Feature;
import gherkin.ast.Scenario;
import gherkin.ast.Step;
import org.junit.Test;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;

public class ParserTest {
    @Test
    public void parses_simple_feature() {
        Parser<Feature> parser = new Parser<>();
        Feature feature = parser.parse("Feature: Hello");
        assertEquals("Hello", feature.getName());
    }

    @Test
    public void parses_feature_with_scenario_and_steps() {
        Parser<Feature> parser = new Parser<>();
        Feature feature = parser.parse("" +
                "Feature: Hello\n" +
                "  The Description\n" +
                "\n" +
                "  Scenario: World\n" +
                "    Given I have 4 cukes\n" +
                "      | a |\n" +
                "      | b |\n");
        assertEquals("Hello", feature.getName());

        Scenario scenario = (Scenario) feature.getScenarioDefinitions().get(0);
        assertEquals("World", scenario.getName());

        Step step = scenario.getSteps().get(0);
        assertEquals("I have 4 cukes", step.getName());

        DataTable table = (DataTable) step.getArgument();
        assertEquals("a", table.getRows().get(0).getCells().get(0).getValue());
    }

    @Test
    public void fail_parser_on_invalid_language_feature() {
        Parser<Feature> parser = new Parser<>();

        try {
            parser.parse("#language:no-such\n" +
                    "\n" +
                    "Feature: Minimal\n" +
                    "\n" +
                    "  Scenario: minimalistic\n" +
                    "    Given the minimalism\n");
        } catch (ParserException.CompositeParserException e) {
            String actualMessage = e.getMessage();
            assertThat(actualMessage, is("Parser errors: \nNo such language: no-such"));
        }
    }

    @Test
    public void fail_parser_on_unexpected_eof() {
        Parser<Feature> parser = new Parser<>();

        try {
            parser.parse("Feature: Unexpected end of file\n" +
                    "\n" +
                    "  Scenario Outline: minimalistic\n" +
                    "    Given the minimalism\n");
        } catch (ParserException.CompositeParserException e) {
            String actualMessage = e.getMessage();
            assertThat(actualMessage, is("Parser errors: \n(5:0): unexpected end of file, expected: #TableRow, #DocStringSeparator, #StepLine, #TagLine, #ExamplesLine, #Comment, #Empty"));
        }
    }
}
