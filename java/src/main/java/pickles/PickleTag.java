package pickles;

public class PickleTag {
    private final String name;
    private final PickleLocation source;

    public PickleTag(String name, PickleLocation source) {
        this.name = name;
        this.source = source;
    }

    public String getName() {
        return name;
    }

    public PickleLocation getSource() {
        return source;
    }
}
