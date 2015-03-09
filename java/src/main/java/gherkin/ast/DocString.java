package gherkin.ast;

public class DocString implements StepArgument {
    private final String type = getClass().getSimpleName();
    private final Location location;
    private final String contentType;
    private final String content;

    public DocString(Location location, String contentType, String content) {
        this.location = location;
        this.contentType = contentType;
        this.content = content;
    }
}
