package gherkin.compiler;

import gherkin.test.Source;
import gherkin.test.TestCaseReceiver;
import gherkin.ast.Background;
import gherkin.ast.BaseVisitor;
import gherkin.ast.ExamplesTable;
import gherkin.ast.Feature;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.test.TestCase;
import gherkin.test.TestStep;

import java.util.ArrayList;
import java.util.List;

public class Compiler {
    private final TestCaseReceiver receiver;

    public Compiler(TestCaseReceiver receiver) {
        this.receiver = receiver;
    }

    public void compile(Feature feature) {
        FeatureCompiler compiler = new FeatureCompiler(new TestCaseBuilder(receiver));
        feature.describeTo(compiler);
    }

    private class TestCaseBuilder {
        private final TestCaseReceiver receiver;
        private final List<TestStep> backgroundTestSteps = new ArrayList<>();
        private List<TestStep> testSteps;

        public TestCaseBuilder(TestCaseReceiver receiver) {
            this.receiver = receiver;
        }

        public void buildStep(Source step) {
            getTestSteps().add(new TestStep(step));
        }

        public void buildTestCase(Source scenarioSource) {
            new TestCase(getTestSteps(), scenarioSource).describeTo(receiver);
        }

        private List<TestStep> getTestSteps() {
            if(testSteps == null) {
                testSteps = new ArrayList<>(backgroundTestSteps);
            }
            return testSteps;
        }
    }

    private class FeatureCompiler extends BaseVisitor {
        private final TestCaseBuilder testCaseBuilder;
        private Source source;

        public FeatureCompiler(TestCaseBuilder testCaseBuilder) {
            this.testCaseBuilder = testCaseBuilder;
        }

        @Override
        public void visitFeature(Feature feature) {
            source = new Source(feature);
        }

        @Override
        public void visitBackground(Background background) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void visitScenario(Scenario scenario) {
            Source scenarioSource = source.concat(scenario);
            ScenarioCompiler scenarioCompiler = new ScenarioCompiler(scenarioSource, testCaseBuilder);
            scenario.describeTo(scenarioCompiler);
            testCaseBuilder.buildTestCase(scenarioSource);
        }

        @Override
        public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void visitExamplesTable(ExamplesTable examplesTable) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void visitStep(Step step) {
        }

        private class ScenarioCompiler extends BaseVisitor {

            private final Source source;
            private final TestCaseBuilder testCaseBuilder;

            public ScenarioCompiler(Source source, TestCaseBuilder testCaseBuilder) {
                this.source = source;
                this.testCaseBuilder = testCaseBuilder;
            }

            @Override
            public void visitScenario(Scenario scenario) {
            }

            @Override
            public void visitStep(Step step) {
                testCaseBuilder.buildStep(source.concat(step));
            }
        }
    }
}
