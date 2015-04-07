package pickles;

import java.util.List;

import static java.util.Arrays.asList;

public class PickleStep {
    private final String text;
    private final PickleArgument argument;
    private final List<PickleLocation> source;

    public PickleStep(String text, PickleArgument argument, PickleLocation... source) {
        this.text = text;
        this.argument = argument;
        this.source = asList(source);
    }

    public String getText() {
        return text;
    }

    public List<PickleLocation> getSource() {
        return source;
    }

    public PickleArgument getArgument() {
        return argument;
    }
}
