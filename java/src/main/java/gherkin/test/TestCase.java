package gherkin.test;

import gherkin.compiler.TestCaseVisitor;

import java.util.ArrayList;
import java.util.List;

public class TestCase {
    private final List<TestStep> testSteps = new ArrayList<>();

    public void addTestStep(TestStep testStep) {
        testSteps.add(testStep);
    }

    public void accept(TestCaseVisitor visitor) {
        for (TestStep testStep : testSteps) {
            testStep.accept(visitor);
        }
        visitor.visitTestCase(this);
    }
}
