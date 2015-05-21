package pickles;

import java.util.List;

import static java.util.Arrays.asList;

public class TestStep {
    private final String text;
    private final StepArgument argument;
    private final List<SourcePointer> source;

    public TestStep(String text, StepArgument argument, SourcePointer... source) {
        this.text = text;
        this.argument = argument;
        this.source = asList(source);
    }

    public String getText() {
        return text;
    }

    public List<SourcePointer> getSource() {
        return source;
    }

    public StepArgument getArgument() {
        return argument;
    }
}
