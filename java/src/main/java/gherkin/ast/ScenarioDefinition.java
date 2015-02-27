package gherkin.ast;

import java.util.List;

public abstract class ScenarioDefinition implements DescribesItself, HasDescription, HasTags, HasAbstractSteps {
    private final List<Tag> tags;
    private final Location location;
    private final String keyword;
    private final String name;
    private final String description;

    public ScenarioDefinition(List<Tag> tags, Location location, String keyword, String name, String description) {
        this.tags = tags;
        this.location = location;
        this.keyword = keyword;
        this.name = name;
        this.description = description;
    }

    @Override
    public String getName() {
        return name;
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
