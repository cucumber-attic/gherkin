package minicuke;

public interface TestListener {
    void testRunStarted();

    void testCaseStarted(TestCase testCase);

    void testStepStarted(TestStep testStep);

    void testStepFinished(TestStep testStep, Status status);

    void testCaseFinished(TestCase testCase);

    void testRunFinished();
}
