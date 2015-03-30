package gherkin.compiler;

import gherkin.ast.Location;
import pickles.Argument;
import pickles.TestStep;

import java.util.List;

import static java.util.Arrays.asList;

public class PickledStep implements TestStep {
    private final String name;
    private final Argument argument;
    private final List<Location> source;

    public PickledStep(String name, Argument argument, Location... source) {
        this.name = name;
        this.argument = argument;
        this.source = asList(source);
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public List<Location> getSource() {
        return source;
    }

    @Override
    public Argument getArgument() {
        return argument;
    }
}
