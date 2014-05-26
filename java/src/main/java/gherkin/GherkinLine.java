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
    public void Detach() {

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
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean StartsWithTitleKeyword(String text) {
        int textLength = text.length();
        return trimmedLineText.length() > textLength &&
                trimmedLineText.startsWith(text) &&
                trimmedLineText.substring(textLength, textLength + GherkinLanguageConstants.TITLE_KEYWORD_SEPARATOR.length())
                        .equals(GherkinLanguageConstants.TITLE_KEYWORD_SEPARATOR);
        // TODO aslak: The C# implementation has another predicate here
    }

    @Override
    public List<GherkinLineSpan> GetTableCells() {
        List<GherkinLineSpan> lineSpans = new ArrayList<GherkinLineSpan>();
        Scanner scanner = new Scanner(trimmedLineText).useDelimiter("\\s*\\|\\s*");
        while (scanner.hasNext()) {
            String cell = scanner.next();
            int column = scanner.match().start() + Indent() + 1;
            lineSpans.add(new GherkinLineSpan(column, cell));
        }
        return lineSpans;
    }
}
