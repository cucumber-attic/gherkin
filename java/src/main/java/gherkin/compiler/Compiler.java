package gherkin.compiler;

import gherkin.ast.Background;
import gherkin.ast.DefaultVisitor;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.test.TestCase;
import gherkin.test.TestStep;

import java.util.ArrayList;
import java.util.List;

public class Compiler {
    private final TestCaseCollection testCaseCollection = new TestCaseCollection();

    public void compile(Feature feature) {
        CompilerVisitor compiler = new CompilerVisitor();
        feature.accept(compiler);
    }

    public TestCaseCollection getTestCaseCollection() {
        return testCaseCollection;
    }

    private class CompilerVisitor extends DefaultVisitor {
        private final List<Step> steps = new ArrayList<>();
        private final List<TestStep> backgroundSteps = new ArrayList<>();
        private final List<ExamplesCompiler> examplesCompilers = new ArrayList<>();

        @Override
        public void visitFeature(Feature feature) {
            backgroundSteps.clear();
        }

        @Override
        public void visitBackground(Background background) {
            for (Step step : steps) {
                String name = step.getKeyword() + step.getName();
                backgroundSteps.add(new TestStep(name, step));
            }
            steps.clear();
        }

        @Override
        public void visitScenario(Scenario scenario) {
            TestCase testCase = createTestCaseWithBackgroundSteps();
            for (Step step : steps) {
                String name = step.getKeyword() + step.getName();
                testCase.addTestStep(new TestStep(name, step));
            }
            steps.clear();
            testCaseCollection.addTestCase(testCase);
        }

        @Override
        public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
            for (ExamplesCompiler examplesCompiler : examplesCompilers) {
                TestCase testCase = createTestCaseWithBackgroundSteps();
                testCaseCollection.addTestCase(testCase);
                examplesCompiler.compile(testCase, steps);
            }
            steps.clear();
            examplesCompilers.clear();
        }

        @Override
        public void visitExamples(Examples examples) {
            ExamplesCompiler examplesCompiler = new ExamplesCompiler(examples);
            examplesCompilers.add(examplesCompiler);
        }

        @Override
        public void visitStep(Step step) {
            steps.add(step);
        }

        private TestCase createTestCaseWithBackgroundSteps() {
            TestCase testCase = new TestCase();
            for (TestStep backgroundStep : backgroundSteps) {
                testCase.addTestStep(backgroundStep);
            }
            return testCase;
        }

    }

}
