package pickles;

public class Tag {
    private final String name;
    private final SourcePointer source;

    public Tag(String name, SourcePointer source) {
        this.name = name;
        this.source = source;
    }
}
