package minicuke;

import gherkin.Parser;
import gherkin.ast.Feature;
import gherkin.compiler.Compiler;
import gherkin.compiler.LineNumber;
import org.junit.Test;
import pickles.Pickle;
import pickles.PickleStep;
import pickles.Uri;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Collections;
import java.util.List;

import static java.util.Collections.singletonList;
import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.*;

public class TestCaseCompilerTest {
    private int offset = LineNumber.get() + 1;
    public static final String SOURCE = "" +
            "Feature: test\n" +
            "  @pie\n" +
            "  Scenario: scenario 1\n" +
            "    Given a\n" +
            "    When b\n" +
            "    Then c\n";

    private List<Pickle> compile(String source, Uri uri) {
        Feature feature = new Parser<Feature>().parse(source);
        return new Compiler().compile(feature, uri, offset);
    }

    @Test
    public void creates_test_case_for_each_pickle() {
        TestCaseCompiler testCaseCompiler = new TestCaseCompiler(Collections.<StepDefinition>emptyList(), Collections.<Hook>emptyList(), Collections.<Hook>emptyList());
        List<Pickle> pickles = compile(SOURCE, Uri.fromThisMethod());
        List<TestCase> testCases = testCaseCompiler.compile(pickles);
        assertEquals(1, testCases.size());
    }

    @Test
    public void creates_test_step_for_each_pickle_step() {
        TestCaseCompiler testCaseCompiler = new TestCaseCompiler(Collections.<StepDefinition>emptyList(), Collections.<Hook>emptyList(), Collections.<Hook>emptyList());
        List<Pickle> pickles = compile(SOURCE, Uri.fromThisMethod());
        List<TestCase> testCases = testCaseCompiler.compile(pickles);
        assertEquals(3, testCases.get(0).getSteps().size());
    }

    @Test
    public void creates_defined_test_step_when_there_is_a_matching_step_definition() {
        StepDefinition stepDefinition = mock(StepDefinition.class);
        when(stepDefinition.matches(any(PickleStep.class))).thenReturn(true);
        when(stepDefinition.matchedArguments("a")).thenReturn(singletonList("the arg"));

        TestCaseCompiler testCaseCompiler = new TestCaseCompiler(singletonList(stepDefinition), Collections.<Hook>emptyList(), Collections.<Hook>emptyList());
        List<Pickle> pickles = compile(SOURCE, Uri.fromThisMethod());
        List<TestCase> testCases = testCaseCompiler.compile(pickles);
        TestStep testStep = testCases.get(0).getSteps().get(0);
        testStep.run();
        verify(stepDefinition).run(singletonList("the arg"));
    }

    @Test
    public void creates_undefined_test_step_when_there_are_no_matching_step_definitions() {
        StepDefinition stepDefinition = mock(StepDefinition.class);
        when(stepDefinition.matches(any(PickleStep.class))).thenReturn(false);

        TestCaseCompiler testCaseCompiler = new TestCaseCompiler(singletonList(stepDefinition), Collections.<Hook>emptyList(), Collections.<Hook>emptyList());
        List<Pickle> pickles = compile(SOURCE, Uri.fromThisMethod());
        List<TestCase> testCases = testCaseCompiler.compile(pickles);
        TestStep testStep = testCases.get(0).getSteps().get(0);
        try {
            testStep.run();
        } catch (UndefinedStepException expected) {
            StringWriter stackTrace = new StringWriter();
            PrintWriter writer = new PrintWriter(stackTrace);
            expected.printStackTrace(writer);
            assertEquals("" +
                            "minicuke.UndefinedStepException: Undefined step: a\n" +
                            "\tat minicuke.TestCaseCompilerTest.creates_undefined_test_step_when_there_are_no_matching_step_definitions(TestCaseCompilerTest.java:28)\n",
                    stackTrace.getBuffer().toString());
            // uncomment below to see trace in IDE and go straight to line
            // throw expected;
        }
    }

    @Test
    public void prepends_test_step_for_each_before_hook() {
        PickleMatcher everything = new EverythingPickleMatcher();
        List<Hook> hooks = singletonList(new Hook(everything));
        TestCaseCompiler testCaseCompiler = new TestCaseCompiler(Collections.<StepDefinition>emptyList(), hooks, Collections.<Hook>emptyList());
        List<Pickle> pickles = compile(SOURCE, Uri.fromThisMethod());
        List<TestCase> testCases = testCaseCompiler.compile(pickles);
        assertEquals(4, testCases.get(0).getSteps().size());
    }

    @Test
    public void omits_before_hooks_that_dont_match_pickle() {
        PickleMatcher nothing = new NothingPickleMatcher();
        List<Hook> hooks = singletonList(new Hook(nothing));
        TestCaseCompiler testCaseCompiler = new TestCaseCompiler(Collections.<StepDefinition>emptyList(), hooks, Collections.<Hook>emptyList());
        List<Pickle> pickles = compile(SOURCE, Uri.fromThisMethod());
        List<TestCase> testCases = testCaseCompiler.compile(pickles);
        assertEquals(3, testCases.get(0).getSteps().size());
    }
}