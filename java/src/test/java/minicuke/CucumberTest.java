package minicuke;

import org.junit.Test;
import pickles.*;

import java.util.ArrayList;
import java.util.List;

import static java.util.Collections.singletonList;
import static org.junit.Assert.assertEquals;

public class CucumberTest {
    private static final List<PickleTag> NO_TAGS = new ArrayList<>();

    @Test
    public void reports_results() {
        List<PickleStep> steps = new ArrayList<>();
        Uri uri = Uri.fromThisMethod(0);
        Pickle pickle = new Pickle(uri, "Eat some cukes", steps, NO_TAGS, new PickleLocation(1, 1));
        PickleStep pickleStep = new PickleStep("I have 5 cukes in my belly", null, uri, new PickleLocation(2, 3));
        steps.add(pickleStep);
        List<Pickle> pickles = singletonList(pickle);

        StepDefinition stepDefinition = new StubStepDefinition();
        List<StepDefinition> stepDefinitions = singletonList(stepDefinition);
        TestCaseCompiler testCaseCompiler = new TestCaseCompiler(stepDefinitions, new ArrayList<Hook>(), new ArrayList<Hook>());
        List<TestCase> testCases = testCaseCompiler.compile(pickles);

        Cucumber cucumber = new Cucumber(testCases);
        TestResultBuilder testResultBuilder = new TestResultBuilder();
        cucumber.run(testResultBuilder);
        assertEquals(Status.SUCCESS, testResultBuilder.getTestCaseResults().get(0).getStatus());
    }

    private class StubStepDefinition implements StepDefinition {
        @Override
        public boolean matches(PickleStep pickleStep) {
            return true;
        }

        @Override
        public void run(List<?> arguments) {
            // success
        }

        @Override
        public List<String> matchedArguments(String text) {
            return new ArrayList<>();
        }
    }
}
