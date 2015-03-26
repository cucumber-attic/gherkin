package gherkin.compiler;

import gherkin.ast.Background;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.ast.Visitor;
import gherkin.test.TestCase;

import java.util.ArrayList;
import java.util.List;

public class Compiler {
    private final TestCaseCollection testCaseCollection = new TestCaseCollection();

    public void compile(Feature feature) {
        FeatureCompiler compiler = new FeatureCompiler();
        feature.describeTo(compiler);
    }

    public TestCaseCollection getTestCaseCollection() {
        return testCaseCollection;
    }

    private class FeatureCompiler implements Visitor {
        private final List<Step> steps = new ArrayList<>();
        private final List<Step> backgroundSteps = new ArrayList<>();

        private TestCase testCase;

        @Override
        public void visitFeature(Feature feature) {
        }

        @Override
        public void visitBackground(Background background) {
            backgroundSteps.addAll(steps);
            steps.clear();
        }

        @Override
        public void visitScenario(Scenario scenario) {
            testCase = new TestCase();
            testCase.appendSteps(backgroundSteps);
            testCase.appendSteps(steps);
            steps.clear();
            testCaseCollection.addTestCase(testCase);
        }

        @Override
        public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void visitExamples(Examples examples) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void visitStep(Step step) {
            steps.add(step);
        }
    }
}
