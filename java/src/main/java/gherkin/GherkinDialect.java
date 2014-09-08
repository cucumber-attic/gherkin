package gherkin;

import java.util.Map;

public class GherkinDialect {
    private final Map<String, String[]> keywords;
    private String language;

    public GherkinDialect(String language, Map<String,String[]> keywords) {
        this.language = language;
        this.keywords = keywords;
    }

    public String[] getFeatureKeywords() {
        return keywords.get("feature");
    }

    public String[] getScenarioKeywords() {
        return keywords.get("scenario");
    }

    public String[] getStepKeywords() {
        return keywords.get("steps");
    }

    public String[] getBackgroundKeywords() {
        return keywords.get("background");
    }

    public String[] getScenarioOutlineKeywords() {
        return keywords.get("scenario_outline");
    }

    public String[] getExamplesKeywords() {
        return keywords.get("examples");
    }

    public String getLanguage() {
        return language;
    }
}
