package gherkin.ast;

public class Step extends Node implements DescribesItself {
    private final String keyword;
    private final String name;
    private final StepArgument argument;

    public Step(Location location, String keyword, String name, StepArgument argument) {
        super(location);
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
