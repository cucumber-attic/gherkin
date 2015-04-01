package pickles;

import pickles.Argument;

import java.util.List;

public class PickledTable implements Argument {
    private final List<List<String>> rows;

    public PickledTable(List<List<String>> rows) {
        this.rows = rows;
    }
}
