package gherkin.pickles;

import java.util.List;

import static java.util.Collections.unmodifiableList;

public class Pickle {
    private final String path;
    private final String keyword;
    private final String name;
    private final List<PickleStep> steps;
    private final List<PickleTag> tags;
    private final List<PickleLocation> locations;

    public Pickle(String path, String keyword, String name, List<PickleStep> steps, List<PickleTag> tags, List<PickleLocation> locations) {
        this.path = path;
        this.keyword = keyword;
        this.name = name;
        this.steps = unmodifiableList(steps);
        this.tags = tags;
        this.locations = unmodifiableList(locations);
    }

    public String getKeyword() {
        return keyword;
    }

    public String getName() {
        return name;
    }

    public List<PickleStep> getSteps() {
        return steps;
    }

    public List<PickleLocation> getLocations() {
        return locations;
    }
}
