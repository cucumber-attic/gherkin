package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class Examples extends Node {
    private final List<Tag> tags;
    private final String keyword;
    private final String name;
    private final String description;
    private final List<TableRow> rows;

    public Examples(Location location, List<Tag> tags, String keyword, String name, String description, List<TableRow> rows) {
        super(location);
        this.tags = Collections.unmodifiableList(tags);
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.rows = Collections.unmodifiableList(rows);
    }

    public String getKeyword() {
        return keyword;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    @Override
    public void accept(Visitor visitor) {
        visitor.visitExamples(this);
    }

    public List<TableRow> getRows() {
        return rows.subList(1, rows.size());
    }

    public TableRow getHeader() {
        return rows.get(0);
    }
}
