package gherkin.ast;

public class Step extends Node {
    private final String keyword;
    private final String name;
    private final Node argument;

    public Step(Location location, String keyword, String name, Node argument) {
        super(location);
        this.keyword = keyword;
        this.name = name;
        this.argument = argument;
    }

    public String getName() {
        return name;
    }

    public String getKeyword() {
        return keyword;
    }

    public Node getArgument() {
        return argument;
    }

}
