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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        GherkinLineSpan that = (GherkinLineSpan) o;
        return Column == that.Column && Text.equals(that.Text);

    }

    @Override
    public int hashCode() {
        int result = Column;
        result = 31 * result + Text.hashCode();
        return result;
    }
}
