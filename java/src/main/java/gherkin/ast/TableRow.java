package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class TableRow {
    private final Location location;
    private final List<TableCell> cells;

    public TableRow(Location location, List<TableCell> cells) {
        this.location = location;
        this.cells = Collections.unmodifiableList(cells);
    }

    public List<TableCell> getCells() {
        return cells;
    }

    public Location getLocation() {
        return location;
    }
}
