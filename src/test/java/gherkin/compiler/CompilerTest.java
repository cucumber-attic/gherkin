package gherkin.compiler;

import gherkin.Parser;
import gherkin.ast.Feature;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;

public class CompilerTest {
    private final Parser<Feature> parser = new Parser<>();
    private StubTestCaseReceiver receiver = new StubTestCaseReceiver();
    private gherkin.compiler.Compiler compiler = new Compiler(receiver);

    @Test
    public void compiles_a_feature_with_a_single_scenario() throws IOException {
        compiler.compile(parser.parse("" +
                "Feature: f\n" +
                "  Scenario: s\n" +
                "    Given passing\n"));
        assertEquals("[test_case, test_step(passing)]", receiver.toString());
    }

    @Test
    public void compiles_a_feature_with_a_background() throws IOException {
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

        assertEquals("[test_case, test_step(a), test_step(b), test_case, test_step(a), test_step(c)]", receiver.toString());
    }
}
