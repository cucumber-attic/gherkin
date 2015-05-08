package minicuke;

import java.util.ArrayList;
import java.util.List;

public class TestCaseResult {
    private Status status = Status.IDLE;
    private final List<TestStepResult> testStepResults = new ArrayList<>();

    public Status getStatus() {
        return status;
    }

    public void addTestStepResult(TestStepResult testStepResult) {
        testStepResults.add(testStepResult);
        status = testStepResult.getStatus();
    }
}
