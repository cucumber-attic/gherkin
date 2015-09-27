package gherkin.compiler;

import gherkin.GherkinDialect;
import gherkin.GherkinDialectProvider;
import gherkin.ast.DataTable;
import gherkin.ast.DocString;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.Node;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioDefinition;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.ast.TableCell;
import gherkin.ast.TableRow;
import gherkin.ast.Tag;

import java.util.ArrayList;
import java.util.List;

public class Compiler {

    public List<TestCase> compile(Feature feature, String path) {
        List<TestCase> testCases = new ArrayList<>();
        List<TestStep> backgroundSteps = new ArrayList<>();
        GherkinDialect dialect = new GherkinDialectProvider().getDialect(feature.getLanguage(), null);
        addBackgroundSteps(feature, backgroundSteps);

        List<Tag> featureTags = feature.getTags();

        for (ScenarioDefinition scenarioDefinition : feature.getScenarioDefinitions()) {
            if (scenarioDefinition instanceof Scenario) {
                addScenarioPickles(testCases, backgroundSteps, (Scenario) scenarioDefinition, featureTags, path);
            } else {
                compileScenarioOutline(testCases, backgroundSteps, dialect, (ScenarioOutline) scenarioDefinition, featureTags, path);
            }
        }
        return testCases;
    }

    private void addScenarioPickles(List<TestCase> testCases, List<TestStep> backgroundSteps, Scenario scenario, List<Tag> featureTags, String path) {
        List<Tag> scenarioTags = new ArrayList<>(featureTags);
        scenarioTags.addAll(scenario.getTags());

        String testCaseName = scenario.getKeyword() + ": " + scenario.getName();
        TestCase testCase = new TestCase(path, testCaseName, backgroundSteps, scenarioTags, scenario.getLocation());
        for (Step step : scenario.getSteps()) {
            TestStep testStep = new TestStep(step.getKeyword() + step.getText(), step.getText(), step.getArgument(), step.getLocation());
            testCase.addTestStep(testStep);
        }
        testCases.add(testCase);
    }

    private void compileScenarioOutline(List<TestCase> testCases, List<TestStep> backgroundSteps, GherkinDialect dialect, ScenarioOutline scenarioOutline, List<Tag> featureTags, String path) {
        String keyword = dialect.getScenarioKeywords().get(0);
        for (final Examples examples : scenarioOutline.getExamples()) {
            TableRow variables = examples.getTableHeader();
            for (final TableRow values : examples.getTableBody()) {
                String scenarioName = interpolate(scenarioOutline.getName(), variables, values);
                String testCaseName = keyword + ": " + scenarioName;

                List<Tag> tags = new ArrayList<>();
                tags.addAll(featureTags);
                tags.addAll(scenarioOutline.getTags());
                tags.addAll(examples.getTags());

                TestCase testCase = new TestCase(
                        path,
                        testCaseName,
                        backgroundSteps,
                        tags,
                        values.getLocation(), scenarioOutline.getLocation());

                for (Step step : scenarioOutline.getSteps()) {
                    String stepText = interpolate(step.getText(), variables, values);

                    // TODO: Use an Array of location in DataTable/DocString as well.
                    // If the Gherkin AST classes supported
                    // a list of locations, we could just reuse the same classes

                    TestStep testStep = new TestStep(
                            step.getKeyword() + stepText,
                            stepText,
                            createTestStepArgument(step.getArgument(), variables, values),
                            values.getLocation(), step.getLocation());
                    testCase.addTestStep(testStep);
                }

                testCases.add(testCase);
            }
        }
    }

    private Node createTestStepArgument(Node argument, TableRow variables, TableRow values) {
        if(argument == null) return null;
        if(argument instanceof DataTable) {
            DataTable t = (DataTable) argument;
            List<TableRow> rows = t.getRows();
            List<TableRow> newRows = new ArrayList<>(rows.size());
            for (TableRow row : rows) {
                List<TableCell> cells = row.getCells();
                List<TableCell> newCells = new ArrayList<>();
                for (TableCell cell : cells) {
                    newCells.add(new TableCell(cell.getLocation(), interpolate(cell.getValue(), variables, values)));
                }
                newRows.add(new TableRow(row.getLocation(), newCells));
            }
            return new DataTable(newRows);
        }
        if(argument instanceof DocString) {
            DocString ds = (DocString) argument;
            return new DocString(ds.getLocation(), ds.getContentType(), interpolate(ds.getContent(), variables, values));
        }
        throw new RuntimeException("Unexpected argument type: " + argument);
    }

    private void addBackgroundSteps(Feature feature, List<TestStep> backgroundSteps) {
        if (feature.getBackground() != null) {
            for (Step step : feature.getBackground().getSteps()) {
                backgroundSteps.add(new TestStep(step.getKeyword() + step.getText(), step.getText(), step.getArgument(), step.getLocation()));
            }
        }
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
}
