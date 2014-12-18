package gherkin.ast;

import java.util.List;

public class Background implements DescribesItself, HasDescription, HasSteps {
    private final Location location;
    private final String keyword;
    private final String title;
    private final String description;
    private final List<Step> steps;

    public Background(Location location, String keyword, String title, String description, List<Step> steps) {
        this.location = location;
        this.keyword = keyword;
        this.title = title;
        this.description = description;
        this.steps = steps;
    }

    public Location getLocation() {
        return location;
    }

    @Override
    public String getKeyword() {
        return keyword;
    }

    @Override
    public String getTitle() {
        return title;
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
        visitor.visitBackground(this);
        for (Step step : steps) {
            step.describeTo(visitor);
        }
    }
}
