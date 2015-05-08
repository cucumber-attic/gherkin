package minicuke;

import java.util.List;

public class TestCase {
    private final List<TestStep> testSteps;

    public TestCase(List<TestStep> testSteps) {
        this.testSteps = testSteps;
    }

    public List<TestStep> getSteps() {
        return testSteps;
    }

    public void run(TestListener testListener) {
        testListener.testCaseStarted(this);
        for (TestStep testStep : testSteps) {
            testStep.run(testListener);
        }
        testListener.testCaseFinished(this);
    }
}
