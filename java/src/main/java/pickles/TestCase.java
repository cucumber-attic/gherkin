package pickles;

import java.util.ArrayList;
import java.util.List;

import static java.util.Arrays.asList;

public class TestCase {
    private final String name;
    private final List<TestStep> steps;
    private final List<Tag> tags;
    private final List<SourcePointer> source;

    public TestCase(String name, List<TestStep> steps, List<Tag> tags, SourcePointer... source) {
        this.name = name;
        this.tags = tags;
        this.steps = new ArrayList<>(steps);
        this.source = asList(source);
    }

    public String getName() {
        return name;
    }

    public List<TestStep> getSteps() {
        return steps;
    }

    public List<SourcePointer> getSource() {
        return source;
    }
}
