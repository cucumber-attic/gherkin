package pickles;

public class StepString implements StepArgument {
    private final String content;

    public StepString(String content) {
        this.content = content;
    }
}
