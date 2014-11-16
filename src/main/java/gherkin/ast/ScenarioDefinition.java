package gherkin.ast;

import java.util.List;

public abstract class ScenarioDefinition implements HasDescription, HasSteps {
    private final List<Tag> tags;
    private final Location location;
    private final String keyword;
    private final String title;
    private final String description;
    private final List<Step> steps;

    public ScenarioDefinition(List<Tag> tags, Location location, String keyword, String title, String description, List<Step> steps) {

        this.tags = tags;
        this.location = location;
        this.keyword = keyword;
        this.title = title;
        this.description = description;
        this.steps = steps;
    }

    @Override
    public String getTitle() {
        return title;
    }

    @Override
    public List<Step> getSteps() {
        return steps;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public Location getLocation() {
        return location;
    }

    @Override
    public String getKeyword() {
        return keyword;
    }

    @Override
    public String getDescription() {
        return description;
    }
}
