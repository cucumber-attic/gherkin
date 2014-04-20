package gherkin;

public class GherkinDialect {
    public String[] getFeatureKeywords() {
        return new String[]{"Feature"};
    }

    public String[] getScenarioKeywords() {
        return new String[]{"Scenario"};
    }

    public String[] getStepKeywords() {
        return new String[]{"Given ", "When ", "Then ", "And ", "But "};
    }

    public String[] getBackgroundKeywords() {
        return new String[]{"Background"};
    }

    public String[] getScenarioOutlineKeywords() {
        return new String[]{"Scenario Outline"};
    }

    public String[] getExamplesKeywords() {
        return new String[]{"Examples"};
    }
}
