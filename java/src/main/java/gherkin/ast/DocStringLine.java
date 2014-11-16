package gherkin.ast;

// TODO: Merge with TableCell and call it Text.
public class DocStringLine {
    private final Location location;
    private final String value;

    public DocStringLine(Location location, String value) {
        this.location = location;
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
