package gherkin;

import gherkin.ast.Location;

public interface IGherkinDialectProvider {
    public GherkinDialect getDefaultDialect();

    GherkinDialect getDialect(String language, Location location);
}
