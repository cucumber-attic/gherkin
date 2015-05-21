package pickles;

import java.util.List;

public class StepTable implements StepArgument {
    private final List<List<String>> rows;

    public StepTable(List<List<String>> rows) {
        this.rows = rows;
    }
}
