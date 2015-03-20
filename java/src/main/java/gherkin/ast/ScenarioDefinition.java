package gherkin.ast;

import java.util.Collections;
import java.util.List;

public abstract class ScenarioDefinition extends Node implements DescribesItself, HasDescription, HasSteps, HasTags {
    private final List<Tag> tags;
    private final String keyword;
    private final String name;
    private final String description;
    private final List<Step> steps;

    public ScenarioDefinition(List<Tag> tags, Location location, String keyword, String name, String description, List<Step> steps) {
        super(location);
        this.tags = Collections.unmodifiableList(tags);
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.steps = Collections.unmodifiableList(steps);
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

    @Override
    public String getKeyword() {
        return keyword;
    }

    @Override
    public String getDescription() {
        return description;
    }
}
