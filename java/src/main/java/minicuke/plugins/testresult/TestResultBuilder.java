package minicuke.plugins.testresult;

import minicuke.Status;
import minicuke.TestCase;
import minicuke.TestListener;
import minicuke.TestStep;

import java.util.ArrayList;
import java.util.List;

public class TestResultBuilder implements TestListener {
    private List<TestCaseResult> testCaseResults = new ArrayList<>();
    private TestCaseResult testCaseResult;

    @Override
    public void testRunStarted() {
    }

    @Override
    public void testCaseStarted(TestCase testCase) {
        testCaseResult = new TestCaseResult(testCase);
        testCaseResults.add(testCaseResult);
    }

    @Override
    public void testStepStarted(TestStep testStep) {
    }

    @Override
    public void testStepFinished(TestStep testStep, Throwable error) {
        StackTraceElement[] testStepStackTrace = testStep.getStackTrace();
        StackTraceElement[] stackTrace;
        Status status;
        if (error != null) {
            // TODO: Similar filtering to Cucumber-JVM's StepDefinitionMatch.removeFrameworkFramesAndAppendStepLocation
            // Where we ask the stepdef to do the filtering.
            // Alternatively, each backend could know how much to filter off by looking for a well-known
            // stacktrace element and add a fixed number N (backend-specific) beyond that. But maybe a
            // simple filter function is better because it's simpler, and it allows filters to be plugged in.
            status = Status.FAILED;
            StackTraceElement[] errorStackTrace = error.getStackTrace();
            stackTrace = new StackTraceElement[testStepStackTrace.length + errorStackTrace.length];
            System.arraycopy(errorStackTrace, 0, stackTrace, 0, errorStackTrace.length);
            System.arraycopy(testStepStackTrace, 0, stackTrace, errorStackTrace.length, testStepStackTrace.length);
        } else {
            status = Status.SUCCESS;
            stackTrace = testStepStackTrace;
        }
        TestStepResult testStepResult = new TestStepResult(stackTrace, status);
        testCaseResult.addTestStepResult(testStepResult);
    }

    @Override
    public void testCaseFinished(TestCase testCase) {
    }

    @Override
    public void testRunFinished() {
    }

    public List<TestCaseResult> getTestCaseResults() {
        return testCaseResults;
    }
}
