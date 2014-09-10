package gherkin.ast;

public class TableCell {
    private final Location location;
    private final String value;

    public TableCell(Location location, String value) {
        this.location = location;
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
