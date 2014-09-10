package gherkin.ast;

public class Step {
    private final Location location;
    private final String keyword;
    private final String name;
    private final StepArgument stepArgument;

    public Step(Location location, String keyword, String name, StepArgument stepArgument) {
        this.location = location;
        this.keyword = keyword;
        this.name = name;
        this.stepArgument = stepArgument;
    }

    public String getName() {
        return name;
    }

    public StepArgument getStepArgument() {
        return stepArgument;
    }
}
