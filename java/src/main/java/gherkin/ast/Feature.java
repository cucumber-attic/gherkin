package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class Feature extends Node implements DescribesItself, HasDescription, HasTags {
    private final List<Tag> tags;
    private final String language;
    private final String keyword;
    private final String name;
    private final String description;
    private final Background background;
    private final List<ScenarioDefinition> scenarioDefinitions;

    public Feature(
            List<Tag> tags,
            Location location,
            String language,
            String keyword,
            String name,
            String description,
            Background background,
            List<ScenarioDefinition> scenarioDefinitions
    ) {
        super(location);
        this.tags = Collections.unmodifiableList(tags);
        this.language = language;
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.background = background;
        this.scenarioDefinitions = Collections.unmodifiableList(scenarioDefinitions);
    }

    public List<ScenarioDefinition> getScenarioDefinitions() {
        return scenarioDefinitions;
    }

    public String getLanguage() {
        return language;
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
    public String getName() {
        return name;
    }

    @Override
    public String getDescription() {
        return description;
    }

    public Background getBackground() {
        return background;
    }

    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitFeature(this);
        if (background != null) {
            background.describeTo(visitor);
        }
        for (ScenarioDefinition scenarioDefinition : scenarioDefinitions) {
            scenarioDefinition.describeTo(visitor);
        }
    }
}
