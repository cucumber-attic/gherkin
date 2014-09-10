package gherkin.ast;

public class Step {
    private final Location location;
    private final String keyword;
    private final String name;
    private final StepArgument argument;

    public Step(Location location, String keyword, String name, StepArgument argument) {
        this.location = location;
        this.keyword = keyword;
        this.name = name;
        this.argument = argument;
    }
}
