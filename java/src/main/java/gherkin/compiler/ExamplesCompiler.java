package gherkin.compiler;

import gherkin.ast.Examples;
import gherkin.ast.Step;
import gherkin.test.TestStep;

import java.util.List;

class ExamplesCompiler {
    private final Examples examples;

    public ExamplesCompiler(Examples examples) {
        this.examples = examples;
    }

    public void compile(List<TestStep> backgroundSteps, List<Step> steps, TestCaseCollection testCaseCollection) {
        ExamplesVisitor visitor = new ExamplesVisitor(steps, testCaseCollection);
        examples.accept(visitor);
    }
}
