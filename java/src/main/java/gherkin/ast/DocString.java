package gherkin.ast;

import java.util.List;

public class DocString implements StepArgument {
    private final Location location;
    private final String contentType;
    private final List<DocStringLine> lines;

    public DocString(Location location, String contentType, List<DocStringLine> lines) {
        this.location = location;
        this.contentType = contentType;
        this.lines = lines;
    }

    public List<DocStringLine> getLines() {
        return lines;
    }

    public String getContentType() {
        return contentType;
    }
}
