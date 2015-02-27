package gherkin.ast;

import java.util.List;

public class ScenarioOutline extends ScenarioDefinition {
    private final List<Step> steps;
    private final List<ExamplesTable> examplesTables;

    public ScenarioOutline(List<Tag> tags, Location location, String keyword, String name, String description, List<Step> steps, List<ExamplesTable> examplesTables) {
        super(tags, location, keyword, name, description);
        this.steps = steps;
        this.examplesTables = examplesTables;
    }

    public List<ExamplesTable> getExamplesTables() {
        return examplesTables;
    }

    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitScenarioOutline(this);
        for (Step step : steps) {
            step.describeTo(visitor);
        }
        for (ExamplesTable examplesTable : examplesTables) {
            examplesTable.describeTo(visitor);
        }
    }

    @Override
    public String getKeyword() {
        throw new UnsupportedOperationException();
    }

    @Override
    public String getName() {
        throw new UnsupportedOperationException();
    }

    @Override
    public String getDescription() {
        throw new UnsupportedOperationException();
    }

    @Override
    public List<Tag> getTags() {
        throw new UnsupportedOperationException();
    }

    @Override
    public List<? extends AbstractStep> getSteps() {
        return steps;
    }
}
