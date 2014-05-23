package gherkin.ast;

public class Location {
    public final int Line;
    private final int Column;

    public Location(int line, int column) {
        Line = line;
        Column = column;
    }
}
