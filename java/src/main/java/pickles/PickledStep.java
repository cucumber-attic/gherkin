package pickles;

import java.util.List;

import static java.util.Arrays.asList;

public class PickledStep {
    private final String name;
    private final Argument argument;
    private final List<Location> source;

    public PickledStep(String name, Argument argument, Location... source) {
        this.name = name;
        this.argument = argument;
        this.source = asList(source);
    }

    public String getName() {
        return name;
    }

    public List<Location> getSource() {
        return source;
    }

    public Argument getArgument() {
        return argument;
    }
}
