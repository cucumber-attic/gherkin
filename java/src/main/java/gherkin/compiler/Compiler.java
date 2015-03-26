package gherkin.compiler;

import gherkin.ast.Background;
import gherkin.ast.DefaultVisitor;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.Location;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import pickles.TestCase;

import java.util.ArrayList;
import java.util.List;

public class Compiler {
    private final List<TestCase> testCases = new ArrayList<>();

    public void compile(Feature feature) {
        CompilerVisitor compiler = new CompilerVisitor();
        feature.accept(compiler);
    }

    public List<TestCase> getTestCases() {
        return testCases;
    }

    private class CompilerVisitor extends DefaultVisitor {
        private final List<Step> steps = new ArrayList<>();
        private final List<CompiledStep> backgroundSteps = new ArrayList<>();
        private final List<ExamplesCompiler> examplesCompilers = new ArrayList<>();

        @Override
        public void visitFeature(Feature feature) {
            backgroundSteps.clear();
        }

        @Override
        public void visitBackground(Background background) {
            for (Step step : steps) {
                String name = step.getKeyword() + step.getName();
                backgroundSteps.add(new CompiledStep(name, step));
            }
            steps.clear();
        }

        @Override
        public void visitScenario(Scenario scenario) {
            String testCaseName = scenario.getKeyword() + ": " + scenario.getName();
            CompiledScenario compiledScenario = createTestCaseWithBackgroundSteps(testCaseName, scenario.getLocation());
            for (Step step : steps) {
                String name = step.getKeyword() + step.getName();
                compiledScenario.addTestStep(new CompiledStep(name, step));
            }
            steps.clear();
            testCases.add(compiledScenario);
        }

        @Override
        public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
            for (ExamplesCompiler examplesCompiler : examplesCompilers) {
                // TODO: Replace <> in name.
                // Also, use the location from the example row
                String testCaseName = scenarioOutline.getKeyword() + ": " + scenarioOutline.getName();
                CompiledScenario compiledScenario = createTestCaseWithBackgroundSteps(testCaseName, scenarioOutline.getLocation());

                testCases.add(compiledScenario);
                examplesCompiler.compile(compiledScenario, steps);
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

        private CompiledScenario createTestCaseWithBackgroundSteps(String name, Location... source) {
            CompiledScenario compiledScenario = new CompiledScenario(name, source);
            for (CompiledStep backgroundStep : backgroundSteps) {
                compiledScenario.addTestStep(backgroundStep);
            }
            return compiledScenario;
        }

    }

}
