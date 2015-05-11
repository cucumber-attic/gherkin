package minicuke;

import pickles.Pickle;

import java.util.List;

public class TestCase {
    private final List<TestStep> testSteps;
    private final Pickle pickle;

    public TestCase(Pickle pickle, List<TestStep> testSteps) {
        this.pickle = pickle;
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

    public String getName() {
        return pickle.getName();
    }

    public StackTraceElement[] getStackTrace() {
        return pickle.getStackTrace();
    }
}
