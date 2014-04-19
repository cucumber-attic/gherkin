package gherkin;

public class GherkinDialect {
    public String[] getFeatureKeywords() {
        return new String[]{"Feature"};
    }

    public String[] getScenarioKeywords() {
        return new String[]{"Scenario"};
    }

    public String[] getStepKeywords() {
        return new String[]{"Given ", "When ", "Then "};
    }
}
