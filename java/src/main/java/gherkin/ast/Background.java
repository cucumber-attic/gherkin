package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class Background extends Node implements DescribesItself, HasDescription, HasSteps {
    private final String keyword;
    private final String name;
    private final String description;
    private final List<Step> steps;

    public Background(Location location, String keyword, String name, String description, List<Step> steps) {
        super(location);
        this.keyword = keyword;
        this.name = name;
        this.description = description;
        this.steps = Collections.unmodifiableList(steps);
    }

    @Override
    public String getKeyword() {
        return keyword;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public List<Step> getSteps() {
        return steps;
    }

    @Override
    public void describeTo(Visitor visitor) {
        for (Step step : steps) {
            step.describeTo(visitor);
        }
        visitor.visitBackground(this);
    }
}
