package gherkin.test;

public class TestStep {
    public TestStep(Source step) {
    }

    public void describeTo(TestCaseReceiver receiver) {
        receiver.visitTestStep(this);
    }
}
