package gherkin;

public class GherkinLineSpan {
    // One-based line position
    public final int Column;

    // Text part of the line
    public final String Text;

    public GherkinLineSpan(int column, String text) {
        Column = column;
        Text = text;
    }
}
