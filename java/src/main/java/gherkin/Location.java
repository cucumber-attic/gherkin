package gherkin;

public class Location {
    private final int lineNumber;
    private int column;

    public Location(int lineNumber) {
        this.lineNumber = lineNumber;
    }

    public void setColumn(int column) {
        this.column = column;
    }

    @Override
    public String toString() {
        return lineNumber + ":" + column;
    }
}
