package gherkin.ast;

public class DocString implements StepArgument {
    private final Location location;
    private final String contentType;
    private final StringBuilder content;

    public DocString(Location location, String contentType, StringBuilder content) {
        this.location = location;
        this.contentType = contentType;
        this.content = content;
    }
}
