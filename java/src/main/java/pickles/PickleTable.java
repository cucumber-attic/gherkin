package pickles;

import java.util.List;

public class PickleTable implements PickleArgument {
    private final List<List<String>> rows;

    public PickleTable(List<List<String>> rows) {
        this.rows = rows;
    }
}
