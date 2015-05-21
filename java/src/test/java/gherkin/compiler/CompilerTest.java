package gherkin.compiler;

import gherkin.Parser;
import gherkin.ast.Feature;
import gherkin.deps.com.google.gson.Gson;
import gherkin.deps.com.google.gson.GsonBuilder;
import org.junit.Test;
import pickles.TestCase;

import java.io.IOException;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class CompilerTest {
    private final Parser<Feature> parser = new Parser<>();
    private final Compiler compiler = new Compiler();
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Test
    public void compiles_a_scenario() throws IOException {
        List<TestCase> testCases = compiler.compile(parser.parse("" +
                "Feature: f\n" +
                "  Scenario: s\n" +
                "    Given passing\n"));

        assertEquals(1, testCases.size());
        assertEquals(1, testCases.get(0).getSteps().size());
        assertEquals("Scenario: s", testCases.get(0).getName());
        assertEquals("passing", testCases.get(0).getSteps().get(0).getText());
//        System.out.println(gson.toJson(testCases));
    }

    @Test
    public void compiles_step_with_data_table() throws IOException {
        List<TestCase> testCases = compiler.compile(parser.parse("" +
                "Feature: f\n" +
                "  Scenario: s\n" +
                "    Given passing\n" +
                "      |x|\n"));

        System.out.println(gson.toJson(testCases));
    }

    @Test
    public void compiles_in_a_background() throws IOException {
        List<TestCase> testCases = compiler.compile(parser.parse("" +
                "Feature: f\n" +
                "  Background:\n" +
                "    Given a\n" +
                "\n" +
                "  Scenario:\n" +
                "    Given b\n" +
                "    \n" +
                "  Scenario:\n" +
                "    Given c\n"));

        System.out.println(gson.toJson(testCases));
    }

    @Test
    public void compiles_a_scenario_outline() throws IOException {
        List<TestCase> testCases = compiler.compile(parser.parse("" +
                "Feature: Minimal Scenario Outline\n" +
                "\n" +
                "  Scenario Outline: <what>\n" +
                "    Given the <what>\n" +
                "\n" +
                "    Examples: \n" +
                "      | what       |\n" +
                "      | minimalism |\n"));

        System.out.println(gson.toJson(testCases));
    }

    @Test
    public void compiles_a_scenario_outline_with_data_tables_and_docstrings() throws IOException {
        List<TestCase> testCases = compiler.compile(parser.parse("" +
                "Feature: Minimal Scenario Outline\n" +
                "\n" +
                "  Scenario Outline: <what>\n" +
                "    Given the table <what>\n" +
                "      | <what> |\n" +
                "    And the docstring <what>\n" +
                "      ```\n" +
                "      doc<what>\n" +
                "      ```\n" +
                "\n" +
                "    Examples: \n" +
                "      | what       |\n" +
                "      | minimalism |\n"));

        System.out.println(gson.toJson(testCases));
    }

    @Test
    public void compiles_a_scenario_outline_with_background() throws IOException {
        List<TestCase> testCases = compiler.compile(parser.parse("" +
                "Feature: Minimal Scenario Outline\n" +
                "  Background:\n" +
                "    Given a\n" +
                "\n" +
                "  Scenario Outline: minimalistic\n" +
                "    Given the <what>\n" +
                "\n" +
                "    Examples: \n" +
                "      | what       |\n" +
                "      | minimalism |\n"));

        System.out.println(gson.toJson(testCases));
    }
}
