package gherkin.compiler;

import gherkin.ast.Location;
import gherkin.ast.Tag;

import java.util.ArrayList;
import java.util.List;

import static java.util.Arrays.asList;

public class TestCase {
    private final String path;
    private final String name;
    private final List<TestStep> steps;
    private final List<Tag> tags;
    private final List<Location> locations;

    public TestCase(String path, String name, List<TestStep> steps, List<Tag> tags, Location... locations) {
        this.path = path;
        this.name = name;
        this.steps = new ArrayList<>(steps);
        this.tags = tags;
        this.locations = asList(locations);
    }

    public void addTestStep(TestStep testStep) {
        steps.add(testStep);
    }

    public String getName() {
        return name;
    }

    public List<TestStep> getSteps() {
        return steps;
    }

    public List<Location> getLocations() {
        return locations;
    }
}
