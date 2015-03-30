package gherkin.ast;

import java.util.Collections;
import java.util.List;

public class Background extends Node {
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

    public String getKeyword() {
        return keyword;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public List<Step> getSteps() {
        return steps;
    }

    @Override
    public void accept(Visitor visitor) {
        visitor.visitBackground(this);
    }
}
