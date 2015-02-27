package gherkin.compiler;

import gherkin.ast.Background;
import gherkin.ast.ExamplesTable;
import gherkin.ast.Feature;
import gherkin.ast.Location;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioDefinition;
import gherkin.ast.ScenarioOutline;
import gherkin.ast.Step;
import gherkin.ast.TableCell;
import gherkin.ast.TableRow;
import gherkin.ast.Tag;
import org.junit.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class CompilerTest {
    private static final List<Tag> EMPTY_TAGS = Collections.emptyList();
    private static final Location LOCATION = new Location(0, 0);
    private static final String SCENARIO = "Scenario";
    private static final String NAME = "Some Name";
    private static final String DESCRIPTION = "Some Description";
    private static final String LANGUAGE = "en";
    private static final String FEATURE = "Feature";
    private static final String GIVEN = "Given ";
    private static final String BACKGROUND = "Background";
    private static final String EXAMPLES = "Examples";

    private List<Step> steps;
    private Background background;
    private List<ScenarioDefinition> scenarioDefinitions;
    private List<ExamplesTable> examplesTables;

    private StubTestCaseReceiver receiver = new StubTestCaseReceiver();
    private gherkin.compiler.Compiler compiler = new Compiler(receiver);
    private List<TableRow> rows;

    @Test
    public void compiles_a_feature_with_a_single_scenario() throws IOException {
        compiler.compile(feature(() -> {
            scenario(() -> {
                step("passing");
            });
        }));
        assertEquals("[test_case, test_step(passing)]", receiver.toString());
    }

    @Test
    public void compiles_a_feature_with_a_background() throws IOException {
        compiler.compile(feature(() -> {
            background(() -> {
                step("a");
            });

            scenario(() -> {
                step("b");
            });

            scenario(() -> {
                step("c");
            });
        }));
        assertEquals("[test_case, test_step(a), test_step(b), test_case, test_step(a), test_step(c)]", receiver.toString());
    }

    @Test
    public void compiles_scenario_outline_to_test_cases() {
        compiler.compile(feature(() -> {
            background(() -> {
                step("background");
            });

            scenarioOutline(() -> {
                step("first <arg>");
                step("second");

                examples(() -> {
                    row("arg");
                    row("1");
                    row("2");
                });

                examples(() -> {
                    row("arg");
                    row("a");
                });
            });

            scenario(() -> {
                step("c");
            });
        }));

        assertEquals("[" +
                "test_case, test_step(background), test_step(first 1), test_step(second), " +
                "test_case, test_step(background), test_step(first 2), test_step(second), " +
                "test_case, test_step(background), test_step(first a), test_step(second), " +
                "test_case, test_step(background), test_step(c)]", receiver.toString());

    }

    private Feature feature(Builder b) {
        scenarioDefinitions = new ArrayList<>();
        b.accept();
        return new Feature(EMPTY_TAGS, LOCATION, LANGUAGE, FEATURE, NAME, DESCRIPTION, background, scenarioDefinitions);
    }

    private void background(Builder b) {
        steps = new ArrayList<>();
        b.accept();
        background = new Background(LOCATION, BACKGROUND, NAME, DESCRIPTION, steps);
    }

    private void scenario(Builder b) {
        steps = new ArrayList<>();
        b.accept();
        Scenario scenario = new Scenario(EMPTY_TAGS, LOCATION, SCENARIO, NAME, DESCRIPTION, steps);
        scenarioDefinitions.add(scenario);
    }

    private void scenarioOutline(Builder b) {
        steps = new ArrayList<>();
        examplesTables = new ArrayList<>();
        b.accept();
        ScenarioOutline scenarioOutline = new ScenarioOutline(EMPTY_TAGS, LOCATION, SCENARIO, NAME, DESCRIPTION, steps, examplesTables);
        scenarioDefinitions.add(scenarioOutline);
    }

    private void examples(Builder b) {
        rows = new ArrayList<>();
        b.accept();
        examplesTables.add(new ExamplesTable(EMPTY_TAGS, LOCATION, EXAMPLES, NAME, DESCRIPTION, rows));
    }

    private void row(String... cellValues) {
        List<TableCell> cells = new ArrayList<>(cellValues.length);
        for (String cellValue : cellValues) {
            cells.add(new TableCell(LOCATION, cellValue));
        }
        rows.add(new TableRow(LOCATION, cells));
    }

    private void step(String name) {
        steps.add(new Step(LOCATION, GIVEN, name, null));
    }

    private interface Builder {
        void accept();
    }

}
