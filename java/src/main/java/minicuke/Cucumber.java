package minicuke;

import java.util.List;

public class Cucumber {
    private final List<TestCase> testCases;

    public Cucumber(List<TestCase> testCases) {
        this.testCases = testCases;
    }

    public void run(TestListener testListener) {
        testListener.testRunStarted();
        for (TestCase testCase : testCases) {
            testCase.run(testListener);
        }
        testListener.testRunFinished();
    }
}
