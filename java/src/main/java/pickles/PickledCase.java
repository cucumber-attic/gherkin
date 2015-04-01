package pickles;

import java.util.ArrayList;
import java.util.List;

import static java.util.Arrays.asList;

public class PickledCase {
    private final List<PickledStep> pickledSteps = new ArrayList<>();

    private final String name;
    private final List<Location> source;

    public PickledCase(String name, Location... source) {
        this.name = name;
        this.source = asList(source);
    }

    public void addTestStep(PickledStep pickledStep) {
        pickledSteps.add(pickledStep);
    }

    public String getName() {
        return name;
    }

    public List<PickledStep> getPickledSteps() {
        return pickledSteps;
    }

    public List<Location> getSource() {
        return source;
    }
}
