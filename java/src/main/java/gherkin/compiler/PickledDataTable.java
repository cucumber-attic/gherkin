package gherkin.compiler;

import pickles.Argument;

import java.util.List;

public class PickledDataTable implements Argument {
    private final List<List<String>> rows;

    public PickledDataTable(List<List<String>> rows) {
        this.rows = rows;
    }
}
