package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class Examples extends Node {
    private final List<Tag> tags;
    private final String keyword;
    private final String name;
    private final String description;
    private final TableRow header;
    private final List<TableRow> body;

    public Examples(Location location, List<Tag> tags, String keyword, String name, String description, TableRow header, List<TableRow> body) {
        super(location);
        this.tags = Collections.unmodifiableList(tags);
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.header = header;
        this.body = Collections.unmodifiableList(body);
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

    public List<TableRow> getBody() {
        return body;
    }

    public TableRow getHeader() {
        return header;
    }

    public List<Tag> getTags() {
        return tags;
    }
}
