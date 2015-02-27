package gherkin.ast;

import java.util.List;

public class Scenario extends ScenarioDefinition {
    private final List<Step> steps;

    public Scenario(List<Tag> tags, Location location, String keyword, String name, String description, List<Step> steps) {
        super(tags, location, keyword, name, description);
        this.steps = steps;
    }

    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitScenario(this);
        for (Step step : steps) {
            step.describeTo(visitor);
        }
    }

    @Override
    public List<? extends AbstractStep> getSteps() {
        return steps;
    }
}
