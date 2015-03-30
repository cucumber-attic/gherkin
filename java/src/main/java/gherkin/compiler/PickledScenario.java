package gherkin.compiler;

import gherkin.ast.Location;
import pickles.TestCase;

import java.util.ArrayList;
import java.util.List;

import static java.util.Arrays.asList;

public class PickledScenario implements TestCase {
    private final List<PickledStep> pickledSteps = new ArrayList<>();

    private final String name;
    private final List<Location> source;

    public PickledScenario(String name, Location... source) {
        this.name = name;
        this.source = asList(source);
    }

    public void addTestStep(PickledStep pickledStep) {
        pickledSteps.add(pickledStep);
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public List<PickledStep> getPickledSteps() {
        return pickledSteps;
    }

    @Override
    public List<Location> getSource() {
        return source;
    }
}
