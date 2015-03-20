package gherkin.ast;

class Node {
    private final String type = getClass().getSimpleName();
    private final Location location;

    protected Node(Location location) {
        this.location = location;
    }

    public Location getLocation() {
        return location;
    }
}
