package gherkin.compiler;

import gherkin.GherkinDialect;
import gherkin.GherkinDialectProvider;
import gherkin.ast.DataTable;
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
import pickles.TestCase;
import pickles.StepArgument;
import pickles.SourcePointer;
import pickles.TestStep;
import pickles.StepString;
import pickles.StepTable;
import pickles.Tag;

import java.util.ArrayList;
import java.util.List;

public class Compiler {

    public List<TestCase> compile(Feature feature) {
        List<TestCase> testCases = new ArrayList<>();
        List<TestStep> backgroundSteps = new ArrayList<>();
        GherkinDialect dialect = new GherkinDialectProvider().getDialect(feature.getLanguage(), null);
        addBackgroundSteps(feature, backgroundSteps);

        List<Tag> featureTags = compile(feature.getTags());

        for (ScenarioDefinition scenarioDefinition : feature.getScenarioDefinitions()) {
            if (scenarioDefinition instanceof Scenario) {
                addScenarioTestCase(testCases, backgroundSteps, (Scenario) scenarioDefinition, featureTags);
            } else {
                addScenarioOutlineTestCases(testCases, backgroundSteps, dialect, (ScenarioOutline) scenarioDefinition, featureTags);
            }
        }
        return testCases;
    }

    private void addScenarioTestCase(List<TestCase> testCases, List<TestStep> backgroundSteps, Scenario scenario, List<Tag> featureTags) {
        List<Tag> scenarioTags = new ArrayList<>(featureTags);
        scenarioTags.addAll(compile(scenario.getTags()));

        String testCaseName = scenario.getKeyword() + ": " + scenario.getName();
        List<TestStep> testSteps = new ArrayList<>(backgroundSteps);

        for (Step step : scenario.getSteps()) {
            StepArgument stepArgument = getStepArgument(step, null, null);
            TestStep testStep = new TestStep(step.getText(), stepArgument, compile(step.getLocation()));
            testSteps.add(testStep);
        }
        testCases.add(new TestCase(testCaseName, testSteps, scenarioTags, compile(scenario.getLocation())));
    }

    private void addScenarioOutlineTestCases(List<TestCase> testCases, List<TestStep> backgroundSteps, GherkinDialect dialect, ScenarioOutline scenarioOutline, List<Tag> featureTags) {
        List<Tag> scenarioOutlineTags = new ArrayList<>(featureTags);
        scenarioOutlineTags.addAll(compile(scenarioOutline.getTags()));

        for (final Examples examples : scenarioOutline.getExamples()) {
            List<Tag> examplesTags = new ArrayList<>(scenarioOutlineTags);
            examplesTags.addAll(compile(examples.getTags()));

            final TableRow header = examples.getTableHeader();
            for (final TableRow values : examples.getTableBody()) {
                String scenarioName = interpolate(scenarioOutline.getName(), examples.getTableHeader(), values);
                String testCaseName = dialect.getScenarioKeywords().get(0) + ": " + scenarioName;
                List<TestStep> testSteps = new ArrayList<>(backgroundSteps);

                for (Step step : scenarioOutline.getSteps()) {
                    StepArgument pickledArgument = getStepArgument(step, header, values);

                    String stepName = interpolate(step.getText(), examples.getTableHeader(), values);
                    TestStep testStep = new TestStep(stepName, pickledArgument, compile(step.getLocation()), compile(values.getLocation()));
                    testSteps.add(testStep);
                }

                testCases.add(new TestCase(testCaseName, testSteps, examplesTags, compile(scenarioOutline.getLocation())));
            }
        }
    }

    private void addBackgroundSteps(Feature feature, List<TestStep> backgroundSteps) {
        if (feature.getBackground() != null) {
            for (Step step : feature.getBackground().getSteps()) {
                StepArgument pickledArgument = getStepArgument(step, null, null);
                backgroundSteps.add(new TestStep(step.getText(), pickledArgument, compile(step.getLocation())));
            }
        }
    }

    private StepArgument getStepArgument(Step step, final TableRow header, final TableRow values) {
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
            return new StepTable(table);
        }
        if (step.getArgument() instanceof DocString) {
            String value = ((DocString) step.getArgument()).getContent();
            return new StepString(interpolate(value, header, values));
        }

        return null;
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

    private List<Tag> compile(List<gherkin.ast.Tag> tags) {
        List<Tag> pickleTags = new ArrayList<>(tags.size());
        for (gherkin.ast.Tag tag : tags) {
            pickleTags.add(compile(tag));
        }
        return pickleTags;
    }

    private Tag compile(gherkin.ast.Tag tag) {
        return new Tag(tag.getName(), compile(tag.getLocation()));
    }

    private SourcePointer compile(Location location) {
        return new SourcePointer(location.getLine(), location.getColumn());
    }
}
