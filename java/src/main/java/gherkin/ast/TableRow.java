package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class TableRow extends Node {
    private final List<TableCell> cells;

    public TableRow(Location location, List<TableCell> cells) {
        super(location);
        this.cells = Collections.unmodifiableList(cells);
    }

    public List<TableCell> getCells() {
        return cells;
    }

    @Override
    public void accept(Visitor visitor) {
        for (TableCell cell : cells) {
            cell.accept(visitor);
        }
        visitor.visitTableRow(this);
    }
}
