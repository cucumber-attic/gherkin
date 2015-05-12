package pickles;

import java.util.List;

import static java.util.Arrays.asList;

public class PickleStep {
    private final String text;
    private final PickleArgument argument;
    private final List<PickleLocation> source;
    private final Uri uri;

    public PickleStep(String text, PickleArgument argument, Uri uri, PickleLocation... source) {
        this.text = text;
        this.argument = argument;
        this.uri = uri;
        this.source = asList(source);
    }

    public String getText() {
        return text;
    }

    public PickleArgument getArgument() {
        return argument;
    }

    public StackTraceElement[] getStackTrace() {
        return StackTrace.create(source, uri);
    }
}
