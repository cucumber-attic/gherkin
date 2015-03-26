package gherkin.compiler;

import gherkin.Parser;
import gherkin.ast.Feature;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;

public class CompilerTest {
    private final Parser<Feature> parser = new Parser<>();
    private final Compiler compiler = new Compiler();
    private final TestCasePrinter printer = new TestCasePrinter();

    @Test
    public void compiles_a_scenario() throws IOException {
        compiler.compile(parser.parse("" +
                "Feature: f\n" +
                "  Scenario: s\n" +
                "    Given passing\n"));
        compiler.getTestCaseCollection().accept(printer);
        assertEquals("[{\"testSteps\":[{\"name\":\"Given passing\"}]}]", printer.getResult());
    }

    @Test
    public void compiles_in_a_background() throws IOException {
        compiler.compile(parser.parse("" +
                "Feature: f\n" +
                "  Background:\n" +
                "    Given a\n" +
                "\n" +
                "  Scenario:\n" +
                "    Given b\n" +
                "    \n" +
                "  Scenario:\n" +
                "    Given c\n"));

        compiler.getTestCaseCollection().accept(printer);
        assertEquals("[{\"testSteps\":[{\"name\":\"Given a\"},{\"name\":\"Given b\"}]},{\"testSteps\":[{\"name\":\"Given a\"},{\"name\":\"Given c\"}]}]", printer.getResult());
    }

    @Test
    public void compiles_a_scenario_outline() throws IOException {
        compiler.compile(parser.parse("" +
                "Feature: Minimal Scenario Outline\n" +
                "\n" +
                "  Scenario Outline: minimalistic\n" +
                "    Given the <what>\n" +
                "\n" +
                "    Examples: \n" +
                "      | what       |\n" +
                "      | minimalism |\n"));
        compiler.getTestCaseCollection().accept(printer);
        System.out.println(printer.getResult());
        assertEquals("[{\"testSteps\":[{\"name\":\"Given the minimalism\"}]}]", printer.getResult());
    }

    @Test
    public void compiles_a_scenario_outline_with_background() throws IOException {
        compiler.compile(parser.parse("" +
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
        compiler.getTestCaseCollection().accept(printer);
        System.out.println(printer.getResult());
        assertEquals("[{\"testSteps\":[{\"name\":\"Given a\"},{\"name\":\"Given the minimalism\"}]}]", printer.getResult());
    }
}
