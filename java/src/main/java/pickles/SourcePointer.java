package pickles;

public class SourcePointer {
    private final int line;
    private final int column;

    public SourcePointer(int line, int column) {
        this.line = line;
        this.column = column;
    }

    public int getLine() {
        return line;
    }

    public int getColumn() {
        return column;
    }
}
