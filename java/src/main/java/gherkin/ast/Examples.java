package gherkin.ast;

import java.util.List;

public class Examples implements HasTags, HasDescription, HasRows {
    private final List<Tag> tags;
    private final Location location;
    private final String keyword;
    private final String title;
    private final String description;
    private final List<TableRow> rows;

    public Examples(List<Tag> tags, Location location, String keyword, String title, String description, List<TableRow> rows) {
        this.tags = tags;
        this.location = location;
        this.keyword = keyword;
        this.title = title;
        this.description = description;
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
}
