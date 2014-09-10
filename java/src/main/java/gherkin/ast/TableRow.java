package gherkin.ast;

import java.util.List;

public class TableRow {
    private final Location location;
    private final List<TableCell> cells;

    public TableRow(Location location, List<TableCell> cells) {
        this.location = location;
        this.cells = cells;
    }

    public List<TableCell> getCells() {
        return cells;
    }

    public Location getLocation() {
        return location;
    }
}
