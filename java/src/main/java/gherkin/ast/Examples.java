package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class Examples extends Node implements DescribesItself, HasTags, HasDescription, HasRows {
    private final List<Tag> tags;
    private final String keyword;
    private final String name;
    private final String description;
    private final TableRow header;
    private final List<TableRow> rows;

    public Examples(Location location, List<Tag> tags, String keyword, String name, String description, TableRow header, List<TableRow> rows) {
        super(location);
        this.tags = Collections.unmodifiableList(tags);
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.header = header;
        this.rows = Collections.unmodifiableList(rows);
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
