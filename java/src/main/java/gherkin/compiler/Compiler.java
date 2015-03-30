package gherkin.compiler;

import gherkin.GherkinDialect;
import gherkin.GherkinDialectProvider;
import gherkin.ast.Background;
import gherkin.ast.DataTable;
import gherkin.ast.DefaultVisitor;
import gherkin.ast.DocString;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.Location;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioDefinition;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.ast.TableCell;
import gherkin.ast.TableRow;
import pickles.Argument;
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
        private final List<PickledStep> backgroundSteps = new ArrayList<>();
        private GherkinDialect dialect;

        @Override
        public void visitFeature(Feature feature) {
            dialect = new GherkinDialectProvider().getDialect(feature.getLanguage(), null);
            if (feature.getBackground() != null) {
                feature.getBackground().accept(this);
            }
            for (ScenarioDefinition scenarioDefinition : feature.getScenarioDefinitions()) {
                scenarioDefinition.accept(this);
            }
        }

        @Override
        public void visitBackground(Background background) {
            for (Step step : background.getSteps()) {
                Argument pickledArgument = getPickledArgument(step, null, null);
                backgroundSteps.add(new PickledStep(step.getName(), pickledArgument, step.getLocation()));
            }
        }

        @Override
        public void visitScenario(Scenario scenario) {
            String testCaseName = scenario.getKeyword() + ": " + scenario.getName();
            PickledScenario pickledScenario = createTestCaseWithBackgroundSteps(testCaseName, scenario.getLocation());
            for (Step step : scenario.getSteps()) {
                Argument pickledArgument = getPickledArgument(step, null, null);
                PickledStep pickledStep = new PickledStep(step.getName(), pickledArgument, step.getLocation());
                pickledScenario.addTestStep(pickledStep);
            }
            testCases.add(pickledScenario);
        }

        @Override
        public void visitScenarioOutline(ScenarioOutline scenarioOutline) {
            for (final Examples examples : scenarioOutline.getExamples()) {
                final TableRow header = examples.getHeader();
                for (final TableRow values : examples.getRows()) {
                    String scenarioName = interpolate(scenarioOutline.getName(), examples.getHeader(), values);
                    String testCaseName = dialect.getScenarioKeywords().get(0) + ": " + scenarioName;

                    PickledScenario pickledScenario = createTestCaseWithBackgroundSteps(testCaseName, scenarioOutline.getLocation());
                    for (Step step : scenarioOutline.getSteps()) {
                        Argument pickledArgument = getPickledArgument(step, header, values);

                        String stepName = interpolate(step.getName(), examples.getHeader(), values);
                        PickledStep pickledStep = new PickledStep(stepName, pickledArgument, step.getLocation(), values.getLocation());
                        pickledScenario.addTestStep(pickledStep);
                    }

                    testCases.add(pickledScenario);
                }
            }
        }

        private Argument getPickledArgument(Step step, final TableRow header, final TableRow values) {
            if (step.getArgument() instanceof DataTable) {
                final List<List<String>> table = new ArrayList<>();
                for (TableRow tableRow : ((DataTable) step.getArgument()).getRows()) {
                    List<String> row = new ArrayList<>();
                    table.add(row);
                    for (TableCell tableCell : tableRow.getCells()) {
                        String cell = interpolate(tableCell.getValue(), header, values);
                        row.add(cell);
                    }
                }
                return new PickledDataTable(table);
            }
            if (step.getArgument() instanceof DocString) {
                String value = ((DocString) step.getArgument()).getContent();
                return new PickledDocString(interpolate(value, header, values));
            }

            return null;
        }

        @Override
        public void visitDocString(DocString docString) {
            throw new UnsupportedOperationException();
        }

        private String interpolate(String name, TableRow variables, TableRow values) {
            int col = 0;
            if (variables != null) {
                for (TableCell headerCell : variables.getCells()) {
                    TableCell valueCell = values.getCells().get(col++);
                    String header = headerCell.getValue();
                    String value = valueCell.getValue();
                    name = name.replace("<" + header + ">", value);
                }
            }
            return name;
        }

        private PickledScenario createTestCaseWithBackgroundSteps(String name, Location... source) {
            PickledScenario pickledScenario = new PickledScenario(name, source);
            for (PickledStep backgroundStep : backgroundSteps) {
                pickledScenario.addTestStep(backgroundStep);
            }
            return pickledScenario;
        }

    }

}
