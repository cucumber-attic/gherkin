package gherkin.ast;

import java.util.List;

public class ScenarioOutline extends ScenarioDefinition {
    private final List<Examples> examples;

    public ScenarioOutline(List<Tag> tags, Location location, String keyword, String name, String description, List<Step> steps, List<Examples> examples) {
        super(tags, location, keyword, name, description, steps);
        this.examples = examples;
    }

    public List<Examples> getExamples() {
        return examples;
    }

    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitScenarioOutline(this);
        for (Step step : getSteps()) {
           step.describeTo(visitor);
        }
        for (Examples examples : this.examples) {
            examples.describeTo(visitor);
        }
    }
}
