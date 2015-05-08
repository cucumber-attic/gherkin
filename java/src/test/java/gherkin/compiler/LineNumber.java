package gherkin.compiler;

public class LineNumber {
    public static int get() {
        return Thread.currentThread().getStackTrace()[2].getLineNumber();
    }
}
