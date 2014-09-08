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
    private final List<ScenarioDefinition> scenariodefinitions;

    public Feature(
            List<Tag> tags,
            Location location,
            String language,
            String keyword,
            String title,
            String description,
            Background background,
            List<ScenarioDefinition> scenariodefinitions
    ) {

        this.tags = tags;
        this.location = location;
        this.language = language;
        this.keyword = keyword;
        this.title = title;
        this.description = description;
        this.background = background;
        this.scenariodefinitions = scenariodefinitions;
    }

    public String getTitle() {
        return title;
    }
}
