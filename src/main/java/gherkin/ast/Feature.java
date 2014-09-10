package gherkin.ast;

import java.util.List;

public class Feature {
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

    public String getTitle() {
        return title;
    }

    public List<ScenarioDefinition> getScenarioDefinitions() {
        return scenarioDefinitions;
    }
}
