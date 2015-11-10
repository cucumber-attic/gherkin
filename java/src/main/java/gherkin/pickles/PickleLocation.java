package gherkin.pickles;

public class PickleLocation {
    private final String path;
    private final int line;
    private final int column;

    public PickleLocation(String path, int line, int column) {
        this.path = path;
        this.line = line;
        this.column = column;
    }

    public String getPath() {
        return path;
    }

    public int getLine() {
        return line;
    }

    public int getColumn() {
        return column;
    }
}
