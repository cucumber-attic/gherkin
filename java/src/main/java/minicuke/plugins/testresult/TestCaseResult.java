package minicuke.plugins.testresult;

import minicuke.Status;
import minicuke.TestCase;

import java.util.ArrayList;
import java.util.List;

public class TestCaseResult {
    private final List<TestStepResult> testStepResults = new ArrayList<>();
    private final StackTraceElement[] stackTrace;
    private Status status = Status.IDLE;

    public TestCaseResult(TestCase testCase) {
        stackTrace = testCase.getStackTrace();
    }

    public Status getStatus() {
        return status;
    }

    public void addTestStepResult(TestStepResult testStepResult) {
        testStepResults.add(testStepResult);
        status = testStepResult.getStatus();
    }
}
