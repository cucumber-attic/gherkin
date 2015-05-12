package pickles;

import java.util.List;

import static java.util.Arrays.asList;

public class Pickle {
    private final Uri uri;
    private final String name;
    private final List<PickleStep> steps;
    private final List<PickleTag> tags;
    private final List<PickleLocation> source;

    public Pickle(Uri uri, String name, List<PickleStep> steps, List<PickleTag> tags, PickleLocation... source) {
        this.uri = uri;
        this.name = name;
        this.tags = tags;
        this.steps = steps;
        this.source = asList(source);
    }

    public void addTestStep(PickleStep pickleStep) {
        steps.add(pickleStep);
    }

    public String getName() {
        return name;
    }

    public List<PickleStep> getSteps() {
        return steps;
    }

    public StackTraceElement[] getStackTrace() {
        return StackTrace.create(source, uri);
    }
}
