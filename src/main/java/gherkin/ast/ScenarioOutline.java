package gherkin.ast;

import java.util.List;

public class ScenarioOutline extends ScenarioDefinition {
    private final List<ExamplesTable> examplesTableList;

    public ScenarioOutline(List<Tag> tags, Location location, String keyword, String name, String description, List<Step> steps, List<ExamplesTable> examplesTableList) {
        super(tags, location, keyword, name, description, steps);
        this.examplesTableList = examplesTableList;
    }

    public List<ExamplesTable> getExamplesTableList() {
        return examplesTableList;
    }

    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitScenarioOutline(this);
        for (Step step : getSteps()) {
           step.describeTo(visitor);
        }
        for (ExamplesTable examplesTable : examplesTableList) {
            examplesTable.describeTo(visitor);
        }
    }
}
