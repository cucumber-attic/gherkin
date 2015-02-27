package gherkin.ast;

public class Step extends AbstractStep {
    public Step(Location location, String keyword, String name, StepArgument stepArgument) {
        super(location, keyword, name, stepArgument);
    }
    @Override
    public void describeTo(Visitor visitor) {
        visitor.visitStep(this);
    }
}
