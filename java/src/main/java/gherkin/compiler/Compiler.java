package gherkin.compiler;

import gherkin.ast.Background;
import gherkin.ast.BaseVisitor;
import gherkin.ast.ExamplesTable;
import gherkin.ast.ExamplesTableRow;
import gherkin.ast.Feature;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioOutline;
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
        public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
            Source scenarioOutlineSource = source.concat(scenarioOutline);
            ScenarioOutlineCompiler scenarioOutlineCompiler = new ScenarioOutlineCompiler(scenarioOutlineSource, testCaseBuilder);
            scenarioOutline.describeTo(scenarioOutlineCompiler);
        }

        @Override
        public void visitStep(Step step) {
        }

        @Override
        public void visitExamplesTable(ExamplesTable examplesTable) {
        }

        @Override
        public void visitExample(ExamplesTableRow examplesTableRow) {
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

        private class ScenarioOutlineCompiler extends BaseVisitor {
            private final List<Step> outlineSteps = new ArrayList<>();
            private final Source scenarioOutlineSource;
            private final TestCaseBuilder testCaseBuilder;
            private ExamplesTable examplesTable;

            public ScenarioOutlineCompiler(Source scenarioOutlineSource, TestCaseBuilder testCaseBuilder) {
                this.scenarioOutlineSource = scenarioOutlineSource;
                this.testCaseBuilder = testCaseBuilder;
            }

            @Override
            public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
            }

            @Override
            public void visitStep(Step outlineStep) {
                outlineSteps.add(outlineStep);
            }

            @Override
            public void visitExamplesTable(ExamplesTable examplesTable) {
                this.examplesTable = examplesTable;
            }

            @Override
            public void visitExample(ExamplesTableRow examplesTableRow) {
                List<Step> steps = getSteps(examplesTableRow);
                Source rowSource = scenarioOutlineSource.concat(examplesTable).concat(examplesTableRow);
                for (Step step : steps) {
                    Source stepSource = rowSource.concat(step);
                    testCaseBuilder.buildStep(stepSource);
                }
                testCaseBuilder.buildTestCase(rowSource);
            }

            private List<Step> getSteps(ExamplesTableRow examplesTableRow) {
                List<Step> steps = new ArrayList<>(outlineSteps.size());
                for (Step outlineStep : outlineSteps) {
                    steps.add(toStep(outlineStep, examplesTableRow));
                }
                return steps;
            }

            private Step toStep(Step outlineStep, ExamplesTableRow examplesTableRow) {
                String stepName = examplesTableRow.expand(outlineStep.getName());
                // TODO: Replace in stepArg too
                return new Step(outlineStep.getLocation(), outlineStep.getKeyword(), stepName, outlineStep.getStepArgument());
            }
        }
    }
}
