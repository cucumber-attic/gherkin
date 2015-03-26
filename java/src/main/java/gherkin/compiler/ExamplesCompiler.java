package gherkin.compiler;

import gherkin.ast.Examples;
import gherkin.ast.Step;
import gherkin.test.TestCase;

import java.util.List;

class ExamplesCompiler {
    private final Examples examples;

    public ExamplesCompiler(Examples examples) {
        this.examples = examples;
    }

    public void compile(TestCase testCase, List<Step> steps) {
        ExamplesVisitor visitor = new ExamplesVisitor(testCase, steps);
        examples.accept(visitor);
    }
}
