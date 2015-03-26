package gherkin.compiler;

import gherkin.ast.Location;
import gherkin.ast.Node;
import pickles.TestStep;

import java.util.ArrayList;
import java.util.List;

public class CompiledStep implements TestStep {
    private final String name;
    private final List<Location> source;

    public CompiledStep(String name, Node... source) {
        this.name = name;
        this.source = new ArrayList<>();
        for (Node node : source) {
            this.source.add(node.getLocation());
        }
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
