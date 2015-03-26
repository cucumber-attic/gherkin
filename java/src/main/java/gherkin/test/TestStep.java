package gherkin.test;

import gherkin.ast.Node;
import gherkin.compiler.TestCaseVisitor;

public class TestStep {
    private final String name;
    private final transient Node[] source;

    public TestStep(String name, Node... source) {
        this.name = name;
        this.source = source;
    }

    public String getName() {
        return name;
    }

    public void accept(TestCaseVisitor visitor) {
        visitor.visitTestStep(this);
    }
}
