package gherkin.compiler;

import gherkin.ast.Background;
import gherkin.ast.Feature;
import gherkin.ast.Location;
import gherkin.ast.Scenario;
import gherkin.ast.ScenarioDefinition;
import gherkin.ast.Step;
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

    private List<Step> steps;
    private Background background;
    private List<ScenarioDefinition> scenarioDefinitions;

    @Test
    public void compiles_a_feature_with_a_single_scenario() throws IOException {
        Feature feature = feature(() -> {
            scenario(() -> {
                step("passing");
            });
        });

        StubTestCaseReceiver receiver = new StubTestCaseReceiver();

        gherkin.compiler.Compiler compiler = new Compiler(receiver);
        compiler.compile(feature);
        assertEquals("[test_case, test_step]", receiver.toString());
    }

    private Feature feature(Builder b) {
        scenarioDefinitions = new ArrayList<>();
        b.accept();
        return new Feature(EMPTY_TAGS, LOCATION, LANGUAGE, FEATURE, NAME, DESCRIPTION, background, scenarioDefinitions);
    }

    private void scenario(Builder b) {
        steps = new ArrayList<>();
        b.accept();
        Scenario scenario = new Scenario(EMPTY_TAGS, LOCATION, SCENARIO, NAME, DESCRIPTION, steps);
        scenarioDefinitions.add(scenario);
    }

    private void step(String name) {
        steps.add(new Step(LOCATION, GIVEN, name, null));
    }

    private interface Builder {
        void accept();
    }

}
