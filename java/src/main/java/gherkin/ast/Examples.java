package gherkin.ast;

import java.util.List;

public class Examples implements DescribesItself, HasTags, HasDescription, HasRows {
    private final String type = getClass().getSimpleName();
    private final List<Tag> tags;
    private final Location location;
    private final String keyword;
    private final String name;
    private final String description;
    private final TableRow header;
    private final List<TableRow> rows;

    public Examples(List<Tag> tags, Location location, String keyword, String name, String description, TableRow header, List<TableRow> rows) {
        this.tags = tags;
        this.location = location;
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.header = header;
        this.rows = rows;
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
    public String getName() {
        return name;
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
        visitor.visitExamples(this);
        // TOTO: iterate over rows
    }
}
