package gherkin;

public class LineSpan {
    private final int column;
    private final String text;

    public LineSpan(int column, String text) {
        this.column = column;
        this.text = text;
    }

    @Override
    public String toString() {
        return String.valueOf(column) + ":" + text;
    }
}
