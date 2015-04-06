package pickles;

public class PickledString implements Argument {
    private final String content;

    public PickledString(String content) {
        this.content = content;
    }
}
