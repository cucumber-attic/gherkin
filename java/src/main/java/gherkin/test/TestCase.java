package gherkin.test;

import gherkin.ast.Step;
import gherkin.compiler.TestCaseVisitor;

import java.util.ArrayList;
import java.util.List;

public class TestCase {
    private final List<TestStep> testSteps = new ArrayList<>();

    public void appendSteps(List<Step> steps) {
        for (Step step : steps) {
            testSteps.add(new TestStep(step));
        }
    }

    public void accept(TestCaseVisitor visitor) {
        for (TestStep testStep : testSteps) {
            testStep.accept(visitor);
        }
        visitor.visitTestCase(this);
    }
}
