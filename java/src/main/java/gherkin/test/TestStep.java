package gherkin.test;

import gherkin.ast.BaseVisitor;
import gherkin.ast.DescribesItself;
import gherkin.ast.Step;

public class TestStep {
    private final Source step;

    public TestStep(Source step) {
        this.step = step;
    }

    public void describeTo(TestCaseReceiver receiver) {
        receiver.visitTestStep(this);
    }

    public String getName() {
        final StringBuilder name = new StringBuilder();
        DescribesItself node = step.getNode();
        node.describeTo(new BaseVisitor() {
            @Override
            public void visitStep(Step step) {
                name.append(step.getName());
            }
        });
        return name.toString();
    }
}
