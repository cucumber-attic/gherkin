package gherkin.compiler;

import gherkin.test.TestCase;
import gherkin.test.TestCaseReceiver;
import gherkin.test.TestStep;

import java.util.ArrayList;
import java.util.List;

class StubTestCaseReceiver implements TestCaseReceiver {
    private final List<String> s = new ArrayList<>();

    @Override
    public void visitTestCase(TestCase testCase) {
        s.add("test_case");
    }

    @Override
    public void visitTestStep(TestStep testStep) {
        s.add("test_step");
    }

    @Override
    public String toString() {
        return s.toString();
    }
}
