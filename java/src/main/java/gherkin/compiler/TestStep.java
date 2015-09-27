package gherkin.compiler;

import gherkin.ast.Location;
import gherkin.ast.Node;

import java.util.List;

import static java.util.Arrays.asList;

public class TestStep {
    private final String name;
    private final String text;
    private final Node argument;
    private final List<Location> locations;

    public TestStep(String name, String text, Node argument, Location... locations) {
        this.name = name;
        this.text = text;
        this.argument = argument;
        this.locations = asList(locations);
    }

    public String getText() {
        return text;
    }

    public List<Location> getLocations() {
        return locations;
    }

    public Node getArgument() {
        return argument;
    }
}
