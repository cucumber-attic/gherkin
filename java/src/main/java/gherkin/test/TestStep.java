package gherkin.test;

import gherkin.ast.Step;
import gherkin.compiler.TestCaseVisitor;

public class TestStep {
    private final transient Step step;
    private final String name;

    public TestStep(Step step) {
        this.step = step;
        this.name = step.getKeyword() + step.getName();
    }

    public String getName() {
        return step.getName();
    }

    public void accept(TestCaseVisitor visitor) {
        visitor.visitTestStep(this);
    }
}
