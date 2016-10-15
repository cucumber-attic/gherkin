package gherkin;

public class Attachment {
    private final String type = "attachment";
    private final Source source;
    private final String data;
    private final Media media = new Media();

    public Attachment(Source source, String data) {
        this.source = source;
        this.data = data;
    }

    public static class Source {
        private final String uri;
        private final Location start;

        public Source(String uri, Location start) {
            this.uri = uri;
            this.start = start;
        }
    }

    public static class Location {
        private final int line;
        private final int column;

        public Location(int line, int column) {
            this.line = line;
            this.column = column;
        }
    }

    public static class Media {
        private final String encoding = "utf-8";
        // Probably the only attachment media type we'll ever use
        // from within this library.
        private final String type = "text/vnd.cucumber.stacktrace.java+plain";
    }
}
