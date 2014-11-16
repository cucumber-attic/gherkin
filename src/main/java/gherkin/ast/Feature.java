package gherkin.ast;

import java.util.List;

public class Feature implements HasDescription, HasTags {
    private final List<Tag> tags;
    private final Location location;
    private final String language;
    private final String keyword;
    private final String title;
    private final String description;
    private final Background background;
    private final List<ScenarioDefinition> scenarioDefinitions;

    public Feature(
            List<Tag> tags,
            Location location,
            String language,
            String keyword,
            String title,
            String description,
            Background background,
            List<ScenarioDefinition> scenarioDefinitions
    ) {

        this.tags = tags;
        this.location = location;
        this.language = language;
        this.keyword = keyword;
        this.title = title;
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
    public String getTitle() {
        return title;
    }

    @Override
    public String getDescription() {
        return description;
    }

    public Background getBackground() {
        return background;
    }
}
