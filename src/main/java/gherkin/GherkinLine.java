package gherkin;

import java.util.List;

public class GherkinLine implements IGherkinLine {
    public GherkinLine(String line, int lineNumber) {

    }

    @Override
    public Integer Indent() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void Detach() {
        throw new UnsupportedOperationException();
    }

    @Override
    public String GetLineText(int indentToRemove) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean IsEmpty() {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean StartsWith(String prefix) {
        throw new UnsupportedOperationException();
    }

    @Override
    public String GetRestTrimmed(int length) {
        throw new UnsupportedOperationException();
    }

    @Override
    public List<GherkinLineSpan> GetTags() {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean StartsWithTitleKeyword(String keyword) {
        throw new UnsupportedOperationException();
    }

    @Override
    public List<GherkinLineSpan> GetTableCells() {
        throw new UnsupportedOperationException();
    }
}
