package gherkin.ast;

public class DocString extends Node {
    private final String contentType;
    private final String content;

    public DocString(Location location, String contentType, String content) {
        super(location);
        this.contentType = contentType;
        this.content = content;
    }

    @Override
    public void accept(Visitor visitor) {
        visitor.visitDocString(this);
    }

    public String getContent() {
        return content;
    }
}
