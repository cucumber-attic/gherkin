package gherkin;

import java.util.List;

public interface IGherkinLine {
    public Integer indent();

    public void detach();

    public String getLineText(int indentToRemove);

    public boolean isEmpty();

    boolean startsWith(String prefix);

    String getRestTrimmed(int length);

    List<GherkinLineSpan> getTags();

    boolean startsWithTitleKeyword(String keyword);

    List<GherkinLineSpan> getTableCells();
}
