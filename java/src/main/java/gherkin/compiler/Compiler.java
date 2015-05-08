package gherkin.compiler;

import gherkin.GherkinDialect;
import gherkin.GherkinDialectProvider;
import gherkin.ast.*;
import pickles.*;

import java.util.ArrayList;
import java.util.List;

public class Compiler {

    public List<Pickle> compile(Feature feature, Uri uri) {
        List<Pickle> pickles = new ArrayList<>();
        List<PickleStep> backgroundSteps = new ArrayList<>();
        GherkinDialect dialect = new GherkinDialectProvider().getDialect(feature.getLanguage(), null);
        addBackgroundSteps(feature, backgroundSteps, uri);

        List<PickleTag> featureTags = pickle(feature.getTags());

        for (ScenarioDefinition scenarioDefinition : feature.getScenarioDefinitions()) {
            if (scenarioDefinition instanceof Scenario) {
                addScenarioPickles(pickles, backgroundSteps, (Scenario) scenarioDefinition, featureTags, uri);
            } else {
                addScenarioOutlinePickles(pickles, backgroundSteps, dialect, (ScenarioOutline) scenarioDefinition, featureTags, uri);
            }
        }
        return pickles;
    }

    private void addScenarioPickles(List<Pickle> pickles, List<PickleStep> backgroundSteps, Scenario scenario, List<PickleTag> featureTags, Uri uri) {
        List<PickleTag> scenarioTags = new ArrayList<>(featureTags);
        scenarioTags.addAll(pickle(scenario.getTags()));

        String testCaseName = scenario.getKeyword() + ": " + scenario.getName();
        Pickle pickle = new Pickle(uri, testCaseName, backgroundSteps, scenarioTags, pickle(scenario.getLocation()));
        for (Step step : scenario.getSteps()) {
            PickleArgument pickledArgument = getPickledArgument(step, null, null);
            PickleStep pickleStep = new PickleStep(step.getText(), pickledArgument, uri, pickle(step.getLocation()));
            pickle.addTestStep(pickleStep);
        }
        pickles.add(pickle);
    }

    private void addScenarioOutlinePickles(List<Pickle> pickles, List<PickleStep> backgroundSteps, GherkinDialect dialect, ScenarioOutline scenarioOutline, List<PickleTag> featureTags, Uri uri) {
        List<PickleTag> scenarioOutlineTags = new ArrayList<>(featureTags);
        scenarioOutlineTags.addAll(pickle(scenarioOutline.getTags()));

        for (final Examples examples : scenarioOutline.getExamples()) {
            List<PickleTag> examplesTags = new ArrayList<>(scenarioOutlineTags);
            examplesTags.addAll(pickle(examples.getTags()));

            final TableRow header = examples.getTableHeader();
            for (final TableRow values : examples.getTableBody()) {
                String scenarioName = interpolate(scenarioOutline.getName(), examples.getTableHeader(), values);
                String testCaseName = dialect.getScenarioKeywords().get(0) + ": " + scenarioName;

                Pickle pickle = new Pickle(uri, testCaseName, backgroundSteps, examplesTags, pickle(scenarioOutline.getLocation()));
                for (Step step : scenarioOutline.getSteps()) {
                    PickleArgument pickledArgument = getPickledArgument(step, header, values);

                    String stepName = interpolate(step.getText(), examples.getTableHeader(), values);
                    PickleStep pickleStep = new PickleStep(stepName, pickledArgument, uri, pickle(step.getLocation()), pickle(values.getLocation()));
                    pickle.addTestStep(pickleStep);
                }

                pickles.add(pickle);
            }
        }
    }

    private void addBackgroundSteps(Feature feature, List<PickleStep> backgroundSteps, Uri uri) {
        if (feature.getBackground() != null) {
            for (Step step : feature.getBackground().getSteps()) {
                PickleArgument pickledArgument = getPickledArgument(step, null, null);
                backgroundSteps.add(new PickleStep(step.getText(), pickledArgument, uri, pickle(step.getLocation())));
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

    private List<PickleTag> pickle(List<Tag> tags) {
        List<PickleTag> pickleTags = new ArrayList<>(tags.size());
        for (Tag tag : tags) {
            pickleTags.add(pickle(tag));
        }
        return pickleTags;
    }

    private PickleTag pickle(Tag tag) {
        return new PickleTag(tag.getName(), pickle(tag.getLocation()));
    }

    private PickleLocation pickle(Location location) {
        return new PickleLocation(location.getLine(), location.getColumn());
    }
}
