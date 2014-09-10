package gherkin.ast;

import java.util.List;

public class DataTable implements StepArgument {
    private final List<TableRow> rows;

    public DataTable(List<TableRow> rows) {
        this.rows = rows;
    }

    public List<TableRow> getRows() {
        return rows;
    }
}
