package gherkin.test;

import gherkin.ast.DescribesItself;

public class Source {
    private final Source parent;
    private final DescribesItself node;

    public Source(DescribesItself node) {
        this(null, node);
    }

    public Source(Source parent, DescribesItself node) {
        this.parent = parent;
        this.node = node;
    }

    public Source concat(DescribesItself node) {
        return new Source(this, node);
    }

    public DescribesItself getNode() {
        return node;
    }
}
