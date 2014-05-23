package gherkin;

import java.util.List;

public interface IGherkinLine {
    public Integer Indent();

    public void Detach();

    public String GetLineText(int indentToRemove);

    public boolean IsEmpty();

    boolean StartsWith(String prefix);

    String GetRestTrimmed(int length);

    List<GherkinLineSpan> GetTags();

    boolean StartsWithTitleKeyword(String keyword);

    List<GherkinLineSpan> GetTableCells();
}
