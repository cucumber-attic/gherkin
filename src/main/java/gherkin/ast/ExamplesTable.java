package gherkin.ast;

import java.util.ArrayList;
import java.util.List;

public class ExamplesTable implements DescribesItself, HasTags, HasDescription, HasRows {
    private final List<Tag> tags;
    private final Location location;
    private final String keyword;
    private final String title;
    private final String description;
    private final List<TableRow> rows;

    private final Header header;
    private final List<Example> examples;

    public ExamplesTable(List<Tag> tags, Location location, String keyword, String title, String description, List<TableRow> rows) {
        this.tags = tags;
        this.location = location;
        this.keyword = keyword;
        this.title = title;
        this.description = description;
        this.rows = rows;

        header = new Header(rows.get(0));
        examples = new ArrayList<>(rows.size() - 1);
        for(int i = 1; i < rows.size(); i++) {
            examples.add(new Example(rows.get(i)));
        }

    }

    @Override
    public List<Tag> getTags() {
        return tags;
    }

    @Override
    public String getKeyword() {
        return keyword;
    }

    @Override
    public String getTitle() {
        return title;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public List<TableRow> getRows() {
        return rows;
    }

    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitExamplesTable(this);
        // TOTO: iterate over rows
    }

    public static class Header {
        private final TableRow tableRow;

        public Header(TableRow tableRow) {
            this.tableRow = tableRow;
        }
    }

    public static class Example {
        private final TableRow tableRow;

        public Example(TableRow tableRow) {
            this.tableRow = tableRow;
        }
    }
}
