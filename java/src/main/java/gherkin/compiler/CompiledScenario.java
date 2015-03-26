package gherkin.compiler;

import gherkin.ast.Location;
import pickles.TestCase;

import java.util.ArrayList;
import java.util.List;

import static java.util.Arrays.asList;

public class CompiledScenario implements TestCase {
    private final List<CompiledStep> testSteps = new ArrayList<>();

    private final String name;
    private final List<Location> source;

    public CompiledScenario(String name, Location... source) {
        this.name = name;
        this.source = asList(source);
    }

    public void addTestStep(CompiledStep compiledStep) {
        testSteps.add(compiledStep);
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public List<CompiledStep> getTestSteps() {
        return testSteps;
    }

    @Override
    public List<Location> getSource() {
        return source;
    }
}
