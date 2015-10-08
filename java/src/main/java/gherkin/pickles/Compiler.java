package gherkin.pickles;

import gherkin.GherkinDialect;
import gherkin.GherkinDialectProvider;
import gherkin.ast.Background;
import gherkin.ast.DataTable;
import gherkin.ast.DocString;
import gherkin.ast.Examples;
import gherkin.ast.Feature;
import gherkin.ast.Location;
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

import static java.util.Arrays.asList;
import static java.util.Collections.emptyList;
import static java.util.Collections.singletonList;
import static java.util.Collections.unmodifiableList;

public class Compiler {

    public List<Pickle> compile(Feature feature, String path) {
        List<Pickle> pickles = new ArrayList<>();
        String scenarioKeyword = getScenarioKeyword(feature);

        List<Tag> featureTags = feature.getTags();
        List<PickleStep> backgroundSteps = getBackgroundSteps(feature.getBackground());

        for (ScenarioDefinition scenarioDefinition : feature.getScenarioDefinitions()) {
            if (scenarioDefinition instanceof Scenario) {
                compileScenario(pickles, backgroundSteps, (Scenario) scenarioDefinition, featureTags, path);
            } else {
                compileScenarioOutline(pickles, backgroundSteps, (ScenarioOutline) scenarioDefinition, featureTags, path, scenarioKeyword);
            }
        }
        return pickles;
    }

    private String getScenarioKeyword(Feature feature) {
        String language = feature.getLanguage();
        if (language != null) {
            GherkinDialect dialect = new GherkinDialectProvider().getDialect(language, null);
            return dialect.getScenarioKeywords().get(0);
        } else {
            return null;
        }
    }

    private void compileScenario(List<Pickle> pickles, List<PickleStep> backgroundSteps, Scenario scenario, List<Tag> featureTags, String path) {
        List<PickleStep> steps = new ArrayList<>();
        steps.addAll(backgroundSteps);

        List<Tag> scenarioTags = new ArrayList<>();
        scenarioTags.addAll(featureTags);
        scenarioTags.addAll(scenario.getTags());

        for (Step step : scenario.getSteps()) {
            steps.add(pickle(step));
        }

        String namePrefix = scenario.getKeyword() == null ? "" : scenario.getKeyword() + ": ";
        String name = namePrefix + scenario.getName();
        Pickle pickle = new Pickle(
                path,
                name,
                steps,
                pickle(scenarioTags),
                singletonList(pickle(scenario.getLocation()))
        );
        pickles.add(pickle);
    }

    private void compileScenarioOutline(List<Pickle> pickles, List<PickleStep> backgroundSteps, ScenarioOutline scenarioOutline, List<Tag> featureTags, String path, String scenarioKeyword) {
        for (final Examples examples : scenarioOutline.getExamples()) {
            List<TableCell> variableCells = examples.getTableHeader().getCells();
            for (final TableRow values : examples.getTableBody()) {
                List<TableCell> valueCells = values.getCells();

                List<PickleStep> steps = new ArrayList<>();
                steps.addAll(backgroundSteps);

                List<Tag> tags = new ArrayList<>();
                tags.addAll(featureTags);
                tags.addAll(scenarioOutline.getTags());
                tags.addAll(examples.getTags());

                for (Step scenarioOutlineStep : scenarioOutline.getSteps()) {
                    String stepText = interpolate(scenarioOutlineStep.getText(), variableCells, valueCells);

                    // TODO: Use an Array of location in DataTable/DocString as well.
                    // If the Gherkin AST classes supported
                    // a list of locations, we could just reuse the same classes

                    PickleStep pickleStep = new PickleStep(
                            stepText,
                            createPickleArguments(scenarioOutlineStep.getArgument(), variableCells, valueCells),
                            asList(
                                    pickle(values.getLocation()),
                                    pickle(scenarioOutlineStep.getLocation())
                            )
                    );
                    steps.add(pickleStep);
                }

                String namePrefix = scenarioKeyword == null ? "" : scenarioKeyword + ": ";
                String name = namePrefix + interpolate(scenarioOutline.getName(), variableCells, valueCells);
                Pickle pickle = new Pickle(
                        path,
                        name,
                        steps,
                        pickle(tags),
                        asList(
                                pickle(values.getLocation()),
                                pickle(scenarioOutline.getLocation())
                        )
                );

                pickles.add(pickle);
            }
        }
    }

    private List<Argument> createPickleArguments(Node argument) {
        List<TableCell> noCells = emptyList();
        return createPickleArguments(argument, noCells, noCells);
    }

    private List<Argument> createPickleArguments(Node argument, List<TableCell> variableCells, List<TableCell> valueCells) {
        List<Argument> result = new ArrayList<>();
        if (argument == null) return result;
        if (argument instanceof DataTable) {
            DataTable t = (DataTable) argument;
            List<TableRow> rows = t.getRows();
            List<PickleRow> newRows = new ArrayList<>(rows.size());
            for (TableRow row : rows) {
                List<TableCell> cells = row.getCells();
                List<PickleCell> newCells = new ArrayList<>();
                for (TableCell cell : cells) {
                    newCells.add(
                            new PickleCell(
                                    pickle(cell.getLocation()),
                                    interpolate(cell.getValue(), variableCells, valueCells)
                            )
                    );
                }
                newRows.add(new PickleRow(newCells));
            }
            result.add(new PickleTable(newRows));
        } else if (argument instanceof DocString) {
            DocString ds = (DocString) argument;
            result.add(
                    new PickleString(
                            pickle(ds.getLocation()),
                            interpolate(ds.getContent(), variableCells, valueCells)
                    )
            );
        } else {
            throw new RuntimeException("Unexpected argument type: " + argument);
        }
        return result;
    }

    private List<PickleStep> getBackgroundSteps(Background background) {
        List<PickleStep> result = new ArrayList<>();
        if (background != null) {
            for (Step step : background.getSteps()) {
                result.add(pickle(step));
            }
        }
        return unmodifiableList(result);
    }

    private PickleStep pickle(Step step) {
        return new PickleStep(
                step.getText(),
                createPickleArguments(step.getArgument()),
                singletonList(pickle(step.getLocation()))
        );
    }

    private String interpolate(String name, List<TableCell> variableCells, List<TableCell> valueCells) {
        int col = 0;
        for (TableCell variableCell : variableCells) {
            TableCell valueCell = valueCells.get(col++);
            String header = variableCell.getValue();
            String value = valueCell.getValue();
            name = name.replace("<" + header + ">", value);
        }
        return name;
    }

    private PickleLocation pickle(Location location) {
        return new PickleLocation(location.getLine(), location.getColumn());
    }

    private List<PickleTag> pickle(List<Tag> tags) {
        List<PickleTag> result = new ArrayList<>();
        for (Tag tag : tags) {
            result.add(pickle(tag));
        }
        return result;
    }

    private PickleTag pickle(Tag tag) {
        return new PickleTag(pickle(tag.getLocation()), tag.getName());
    }
}
