package gherkin.compiler;

import gherkin.GherkinDialect;
import gherkin.GherkinDialectProvider;
import gherkin.ast.*;
import pickles.*;

import java.util.ArrayList;
import java.util.List;

public class Compiler {

    public List<Pickle> compile(Feature feature, Uri Uri, int offset) {
        List<Pickle> pickles = new ArrayList<>();
        List<PickleStep> backgroundSteps = new ArrayList<>();
        GherkinDialect dialect = new GherkinDialectProvider().getDialect(feature.getLanguage(), null);
        addBackgroundSteps(feature, backgroundSteps, Uri, offset);

        List<PickleTag> featureTags = pickle(feature.getTags(), offset);

        for (ScenarioDefinition scenarioDefinition : feature.getScenarioDefinitions()) {
            if (scenarioDefinition instanceof Scenario) {
                addScenarioPickles(pickles, backgroundSteps, (Scenario) scenarioDefinition, featureTags, Uri, offset);
            } else {
                addScenarioOutlinePickles(pickles, backgroundSteps, dialect, (ScenarioOutline) scenarioDefinition, featureTags, Uri, offset);
            }
        }
        return pickles;
    }

    private void addScenarioPickles(List<Pickle> pickles, List<PickleStep> backgroundSteps, Scenario scenario, List<PickleTag> featureTags, Uri uri, int offset) {
        List<PickleTag> scenarioTags = new ArrayList<>(featureTags);
        scenarioTags.addAll(pickle(scenario.getTags(), offset));

        String testCaseName = scenario.getKeyword() + ": " + scenario.getName();
        Pickle pickle = new Pickle(uri, testCaseName, backgroundSteps, scenarioTags, pickle(scenario.getLocation(), offset));
        for (Step step : scenario.getSteps()) {
            PickleArgument pickledArgument = getPickledArgument(step, null, null);
            PickleStep pickleStep = new PickleStep(step.getText(), pickledArgument, uri, pickle(step.getLocation(), offset));
            pickle.addTestStep(pickleStep);
        }
        pickles.add(pickle);
    }

    private void addScenarioOutlinePickles(List<Pickle> pickles, List<PickleStep> backgroundSteps, GherkinDialect dialect, ScenarioOutline scenarioOutline, List<PickleTag> featureTags, Uri uri, int offset) {
        List<PickleTag> scenarioOutlineTags = new ArrayList<>(featureTags);
        scenarioOutlineTags.addAll(pickle(scenarioOutline.getTags(), offset));

        for (final Examples examples : scenarioOutline.getExamples()) {
            List<PickleTag> examplesTags = new ArrayList<>(scenarioOutlineTags);
            examplesTags.addAll(pickle(examples.getTags(), offset));

            final TableRow header = examples.getTableHeader();
            for (final TableRow values : examples.getTableBody()) {
                String scenarioName = interpolate(scenarioOutline.getName(), examples.getTableHeader(), values);
                String testCaseName = dialect.getScenarioKeywords().get(0) + ": " + scenarioName;

                Pickle pickle = new Pickle(uri, testCaseName, backgroundSteps, examplesTags, pickle(scenarioOutline.getLocation(), offset));
                for (Step step : scenarioOutline.getSteps()) {
                    PickleArgument pickledArgument = getPickledArgument(step, header, values);

                    String stepName = interpolate(step.getText(), examples.getTableHeader(), values);
                    PickleStep pickleStep = new PickleStep(stepName, pickledArgument, uri, pickle(step.getLocation(), offset), pickle(values.getLocation(), offset));
                    pickle.addTestStep(pickleStep);
                }

                pickles.add(pickle);
            }
        }
    }

    private void addBackgroundSteps(Feature feature, List<PickleStep> backgroundSteps, Uri uri, int offset) {
        if (feature.getBackground() != null) {
            for (Step step : feature.getBackground().getSteps()) {
                PickleArgument pickledArgument = getPickledArgument(step, null, null);
                backgroundSteps.add(new PickleStep(step.getText(), pickledArgument, uri, pickle(step.getLocation(), offset)));
            }
        }
    }

    private PickleArgument getPickledArgument(Step step, final TableRow header, final TableRow values) {
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
            return new PickleTable(table);
        }
        if (step.getArgument() instanceof DocString) {
            String value = ((DocString) step.getArgument()).getContent();
            return new PickleString(interpolate(value, header, values));
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

    private List<PickleTag> pickle(List<Tag> tags, int offset) {
        List<PickleTag> pickleTags = new ArrayList<>(tags.size());
        for (Tag tag : tags) {
            pickleTags.add(pickle(tag, offset));
        }
        return pickleTags;
    }

    private PickleTag pickle(Tag tag, int offset) {
        return new PickleTag(tag.getName(), pickle(tag.getLocation(), offset));
    }

    private PickleLocation pickle(Location location, int offset) {
        return new PickleLocation(location.getLine() + offset, location.getColumn());
    }
}
