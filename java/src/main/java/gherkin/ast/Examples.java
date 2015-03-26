package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class Examples extends Node {
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
        header.accept(visitor);
        for (TableRow tableRow : rows) {
            tableRow.accept(visitor);
        }
        visitor.visitExamples(this);
    }
}
