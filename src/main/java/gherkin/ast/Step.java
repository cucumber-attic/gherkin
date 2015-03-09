package gherkin.ast;

public class Step implements DescribesItself {
    private final String type = getClass().getSimpleName();
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

    public String getName() {
        return name;
    }

    public StepArgument getArgument() {
        return argument;
    }

    public String getKeyword() {
        return keyword;
    }

    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitStep(this);
    }
}
