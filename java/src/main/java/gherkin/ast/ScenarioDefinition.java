package gherkin.ast;

import java.util.List;

public abstract class ScenarioDefinition implements DescribesItself, HasDescription, HasSteps, HasTags {
    private final String type = getClass().getSimpleName();
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

    @Override
    public String getName() {
        return name;
    }

    @Override
    public List<Step> getSteps() {
        return steps;
    }

    @Override
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
