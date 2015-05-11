package minicuke;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.junit.Test;
import pickles.Pickle;
import pickles.PickleLocation;
import pickles.PickleStep;
import pickles.PickleTag;
import pickles.Uri;

import java.util.ArrayList;
import java.util.List;

import static java.util.Collections.singletonList;
import static org.junit.Assert.assertEquals;

public class CucumberTest {
    private static final List<PickleTag> NO_TAGS = new ArrayList<>();

    @Test
    public void reports_results_for_passing_step_definition() {
        List<TestCaseResult> testCaseResults = runCucumber(createPickles(), new PassingStepDefinition());

        assertEquals(Status.SUCCESS, testCaseResults.get(0).getStatus());
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(testCaseResults);
        System.out.println(json);
    }

    @Test
    public void reports_results_for_failing_step_definition() {
        List<TestCaseResult> testCaseResults = runCucumber(createPickles(), new FailingStepDefinition());

        assertEquals(Status.FAILED, testCaseResults.get(0).getStatus());
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json = gson.toJson(testCaseResults);
        System.out.println(json);
    }

    private List<TestCaseResult> runCucumber(List<Pickle> pickles, StepDefinition stepDefinition) {
        List<StepDefinition> stepDefinitions = singletonList(stepDefinition);
        TestCaseCompiler testCaseCompiler = new TestCaseCompiler(stepDefinitions, new ArrayList<Hook>(), new ArrayList<Hook>());
        List<TestCase> testCases = testCaseCompiler.compile(pickles);

        Cucumber cucumber = new Cucumber(testCases);
        TestResultBuilder testResultBuilder = new TestResultBuilder();
        cucumber.run(testResultBuilder);
        return testResultBuilder.getTestCaseResults();
    }

    private List<Pickle> createPickles() {
        List<PickleStep> steps = new ArrayList<>();
        Uri uri = Uri.fromThisMethod(0);
        Pickle pickle = new Pickle(uri, "Eat some cukes", steps, NO_TAGS, new PickleLocation(1, 1));
        PickleStep pickleStep = new PickleStep("I have 5 cukes in my belly", null, uri, new PickleLocation(2, 3));
        steps.add(pickleStep);
        return singletonList(pickle);
    }

    private class PassingStepDefinition implements StepDefinition {
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

    private class FailingStepDefinition implements StepDefinition {
        @Override
        public boolean matches(PickleStep pickleStep) {
            return true;
        }

        @Override
        public void run(List<?> arguments) {
            assertEquals(1, 2);
        }

        @Override
        public List<String> matchedArguments(String text) {
            return new ArrayList<>();
        }
    }
}
