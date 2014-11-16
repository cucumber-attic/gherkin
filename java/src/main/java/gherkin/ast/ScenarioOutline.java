package gherkin.ast;

import java.util.List;

public class ScenarioOutline extends ScenarioDefinition {
    private final List<Examples> examplesList;

    public ScenarioOutline(List<Tag> tags, Location location, String keyword, String name, String description, List<Step> steps, List<Examples> examplesList) {
        super(tags, location, keyword, name, description, steps);
        this.examplesList = examplesList;
    }

    public List<Examples> getExamplesList() {
        return examplesList;
    }
}
