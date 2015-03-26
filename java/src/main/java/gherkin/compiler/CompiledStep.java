package gherkin.compiler;

import gherkin.ast.Location;
import pickles.TestStep;

import java.util.List;

import static java.util.Arrays.asList;

public class CompiledStep implements TestStep {
    private final String name;
    private final List<Location> source;

    public CompiledStep(String name, Location... source) {
        this.name = name;
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
}
