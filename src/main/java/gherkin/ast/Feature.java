package gherkin.ast;

import java.util.List;

public class Feature implements DescribesItself, HasDescription, HasTags {
    private final String type = getClass().getSimpleName();
    private final List<Tag> tags;
    private final Location location;
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

        this.tags = tags;
        this.location = location;
        this.language = language;
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.background = background;
        this.scenarioDefinitions = scenarioDefinitions;
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

    public Location getLocation() {
        return location;
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
        if(background != null) {
            background.describeTo(visitor);
        }
        for (ScenarioDefinition scenarioDefinition : scenarioDefinitions) {
            scenarioDefinition.describeTo(visitor);
        }
    }
}
