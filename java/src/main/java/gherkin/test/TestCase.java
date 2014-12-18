package gherkin.test;

import java.util.List;

public class TestCase {
    private final List<TestStep> testSteps;
    private final Source scenarioSource;

    public TestCase(List<TestStep> testSteps, Source scenarioSource) {
        this.testSteps = testSteps;
        this.scenarioSource = scenarioSource;
    }

    public void describeTo(TestCaseReceiver receiver) {
        receiver.visitTestCase(this);
        for (TestStep testStep : testSteps) {
            testStep.describeTo(receiver);
        }
    }
}
