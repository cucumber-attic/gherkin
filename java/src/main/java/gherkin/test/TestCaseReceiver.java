package gherkin.test;

public interface TestCaseReceiver {
    void visitTestCase(TestCase testCase);

    void visitTestStep(TestStep testStep);
}
