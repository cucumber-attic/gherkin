package gherkin.pickles;

import java.util.List;

import static java.util.Collections.unmodifiableList;

public class PickleStep {
    private final String keyword;
    private final String text;
    private final List<Argument> arguments;
    private final List<PickleLocation> locations;

    public PickleStep(String keyword, String text, List<Argument> arguments, List<PickleLocation> locations) {
        this.keyword = keyword;
        this.text = text;
        this.arguments = unmodifiableList(arguments);
        this.locations = unmodifiableList(locations);
    }

    public String getKeyword() {
        return keyword;
    }

    public String getText() {
        return text;
    }

    public List<PickleLocation> getLocations() {
        return locations;
    }

    public List<Argument> getArgument() {
        return arguments;
    }
}
