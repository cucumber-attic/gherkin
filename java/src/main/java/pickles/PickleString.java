package pickles;

public class PickleString implements PickleArgument {
    private final String content;

    public PickleString(String content) {
        this.content = content;
    }
}
