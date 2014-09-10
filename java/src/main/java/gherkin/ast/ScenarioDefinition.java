package gherkin.ast;

import java.util.List;

public class ScenarioDefinition {
    private final List<Tag> tags;
    private final Location location;
    private final String keyword;
    private final String name;
    private final String description;
    private final List<Step> steps;

    public ScenarioDefinition(List<Tag> tags, Location location, String keyword, String name, String description, List<Step> steps) {

        this.tags = tags;
        this.location = location;
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.steps = steps;
    }

    public String getTitle() {
        return name;
    }
}
