package minicuke;

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
        testCaseResult = new TestCaseResult();
        testCaseResults.add(testCaseResult);
    }

    @Override
    public void testStepStarted(TestStep testStep) {
    }

    @Override
    public void testStepFinished(TestStep testStep, Status status) {
        TestStepResult testStepResult = new TestStepResult(testStep.getStackTrace(), status);
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
