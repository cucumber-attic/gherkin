package gherkin.ast;

import java.util.List;

public class Scenario extends ScenarioDefinition {
    public Scenario(List<Tag> tags, Location location, String keyword, String name, String description, List<Step> steps) {
        super(tags, location, keyword, name, description, steps);
    }

    @Override
    public void describeTo(Visitor visitor) {
        for (Step step : getSteps()) {
            step.describeTo(visitor);
        }
        visitor.visitScenario(this);
    }
}
