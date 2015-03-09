package gherkin;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import static gherkin.StringUtils.ltrim;

public class GherkinLine implements IGherkinLine {
    private final String lineText;
    private final int lineNumber;
    private final String trimmedLineText;

    public GherkinLine(String lineText, int lineNumber) {
        this.lineText = lineText;
        this.lineNumber = lineNumber;
        this.trimmedLineText = ltrim(lineText);
    }

    @Override
    public Integer Indent() {
        return lineText.length() - trimmedLineText.length();
    }

    @Override
    public void detach() {

    }

    @Override
    public String GetLineText(int indentToRemove) {
        return lineText;
    }

    @Override
    public boolean IsEmpty() {
        return trimmedLineText.length() == 0;
    }

    @Override
    public boolean StartsWith(String prefix) {
        return trimmedLineText.startsWith(prefix);
    }

    @Override
    public String GetRestTrimmed(int length) {
        return trimmedLineText.substring(length).trim();
    }

    @Override
    public List<GherkinLineSpan> GetTags() {
        return getSpans("\\s+");
    }

    @Override
    public boolean StartsWithTitleKeyword(String text) {
        int textLength = text.length();
        return trimmedLineText.length() > textLength &&
                trimmedLineText.startsWith(text) &&
                trimmedLineText.substring(textLength, textLength + GherkinLanguageConstants.TITLE_KEYWORD_SEPARATOR.length())
                        .equals(GherkinLanguageConstants.TITLE_KEYWORD_SEPARATOR);
        // TODO aslak: extract startsWithFrom method for clarity
    }

    @Override
    public List<GherkinLineSpan> GetTableCells() {
        return getSpans("\\s*\\|\\s*");
    }

    private List<GherkinLineSpan> getSpans(String delimiter) {
        List<GherkinLineSpan> lineSpans = new ArrayList<GherkinLineSpan>();
        Scanner scanner = new Scanner(trimmedLineText).useDelimiter(delimiter);
        while (scanner.hasNext()) {
            String cell = scanner.next();
            int column = scanner.match().start() + Indent() + 1;
            lineSpans.add(new GherkinLineSpan(column, cell));
        }
        return lineSpans;
    }
}
