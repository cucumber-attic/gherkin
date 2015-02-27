package gherkin.ast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExamplesTable implements DescribesItself, HasTags, HasDescription, HasRows {
    private final List<Tag> tags;
    private final Location location;
    private final String keyword;
    private final String title;
    private final String description;
    private final List<TableRow> rows;

    private final Header header;
    private final List<ExamplesTableRow> examplesTableRows;

    public ExamplesTable(List<Tag> tags, Location location, String keyword, String title, String description, List<TableRow> rows) {
        this.tags = tags;
        this.location = location;
        this.keyword = keyword;
        this.title = title;
        this.description = description;
        this.rows = rows;

        header = new Header(rows.get(0));
        examplesTableRows = new ArrayList<>(rows.size() - 1);
        for (int i = 1; i < rows.size(); i++) {
//            examplesTableRows.add(new ExamplesTableRow(rows.get(i)));
            examplesTableRows.add(header.buildRow(rows.get(i)));
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
    public String getName() {
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
        for (ExamplesTableRow examplesTableRow : examplesTableRows) {
            examplesTableRow.describeTo(visitor);
        }
    }

    public static class Header {
        private final TableRow headerRow;

        public Header(TableRow headerRow) {
            this.headerRow = headerRow;
        }

        public ExamplesTableRow buildRow(TableRow dataRow) {
            Map<String, String> data = new HashMap<>();
            int i = 0;
            for (TableCell tableCell : headerRow.getCells()) {
                data.put(tableCell.getValue(), dataRow.getCells().get(i++).getValue());
            }
            return new ExamplesTableRow(data);
        }
    }

}
