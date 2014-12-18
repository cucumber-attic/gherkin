package gherkin.compiler;

import gherkin.ast.Background;
import gherkin.ast.BaseVisitor;
import gherkin.ast.Feature;
import gherkin.ast.Scenario;
import gherkin.ast.Step;
import gherkin.test.Source;
import gherkin.test.TestCase;
import gherkin.test.TestCaseReceiver;
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

        public void buildBackgroundStep(Source step) {
            backgroundTestSteps.add(new TestStep(step));
        }

        public void buildStep(Source step) {
            getTestSteps().add(new TestStep(step));
        }

        public void buildTestCase(Source scenario) {
            new TestCase(getTestSteps(), scenario).describeTo(receiver);
            testSteps = null;
        }

        private List<TestStep> getTestSteps() {
            if (testSteps == null) {
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
            Source backgroundSource = source.concat(background);
            BackgroundCompiler backgroundCompiler = new BackgroundCompiler(backgroundSource, testCaseBuilder);
            background.describeTo(backgroundCompiler);
        }

        @Override
        public void visitScenario(Scenario scenario) {
            Source scenarioSource = source.concat(scenario);
            ScenarioCompiler scenarioCompiler = new ScenarioCompiler(scenarioSource, testCaseBuilder);
            scenario.describeTo(scenarioCompiler);
            testCaseBuilder.buildTestCase(scenarioSource);
        }

        @Override
        public void visitStep(Step step) {
        }

        private class BackgroundCompiler extends BaseVisitor {
            private final Source source;
            private final TestCaseBuilder testCaseBuilder;

            public BackgroundCompiler(Source source, TestCaseBuilder testCaseBuilder) {
                this.source = source;
                this.testCaseBuilder = testCaseBuilder;
            }

            @Override
            public void visitBackground(Background background) {
            }

            @Override
            public void visitStep(Step step) {
                testCaseBuilder.buildBackgroundStep(source.concat(step));
            }
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
