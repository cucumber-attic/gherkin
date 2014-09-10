package gherkin.ast;

public class Tag {
    private final Location location;
    private final String name;

    public Tag(Location location, String name) {
        this.location = location;
        this.name = name;
    }
}
