package gherkin;

public class TokenMatcherFactory {
    static Parser.ITokenMatcher getTokenMatcher(String fileName) {
        String ext = getFileExtension(fileName);
        switch (ext) {
            case "feature":
                return new GherkinTokenMatcher();
            case "markdown":
            case "md":
                return new MarkdownTokenMatcher();
            default:
                throw new ParserException("Don't know how to parse " + fileName);
        }
    }

    private static String getFileExtension(String fileName) {
        String extension = "";

        int i = fileName.lastIndexOf('.');
        int p = Math.max(fileName.lastIndexOf('/'), fileName.lastIndexOf('\\'));

        if (i > p) {
            extension = fileName.substring(i + 1);
        }
        return extension;
    }
}
