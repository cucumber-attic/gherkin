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

    public List<PickleLocation> getSource() {
        return source;
    }

    public PickleArgument getArgument() {
        return argument;
    }

    public Uri getUri() {
        return uri;
    }

    public StackTraceElement[] getStackTrace() {
        StackTraceElement[] frames = new StackTraceElement[getSource().size()];
        int i = 0;
        for (PickleLocation pickleLocation : source) {
            frames[i++] = new StackTraceElement(uri.getDeclaringClassForStackTrace(), uri.getMethodNameForStackTrace(), uri.getFileName(), pickleLocation.getLine());
        }
        return frames;
    }
}
